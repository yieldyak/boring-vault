// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BoringVault} from "src/base/BoringVault.sol";
import {MerkleProofLib} from "@solmate/utils/MerkleProofLib.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {Auth, Authority} from "@solmate/auth/Auth.sol";
import {IPausable} from "src/interfaces/IPausable.sol";

contract BarebonesManagerWithMerkleVerification is Auth, IPausable {
    using SafeTransferLib for ERC20;
    using Address for address;

    // ========================================= STATE =========================================

    /**
     * @notice A merkle tree root that restricts what data can be passed to the BoringVault.
     * @dev Maps a strategist address to their specific merkle root.
     * @dev Each leaf is composed of the keccak256 hash of abi.encodePacked {decodersAndSanitizer, target, valueIsNonZero, selector, argumentAddress_0, ...., argumentAddress_N}
     *      Where:
     *             - decodersAndSanitizer is the addres to call to extract packed address arguments from the calldata
     *             - target is the address to make the call to
     *             - valueIsNonZero is a bool indicating whether or not the value is non-zero
     *             - selector is the function selector on target
     *             - argumentAddress is each allowed address argument in that call
     */
    mapping(address => bytes32) public manageRoot;

    /**
     * @notice Used to pause calls to `manageVaultWithMerkleVerification`.
     */
    bool public isPaused;

    //============================== ERRORS ===============================

    error BarebonesManagerWithMerkleVerification__InvalidManageProofLength();
    error BarebonesManagerWithMerkleVerification__InvalidTargetDataLength();
    error BarebonesManagerWithMerkleVerification__InvalidValuesLength();
    error BarebonesManagerWithMerkleVerification__InvalidDecodersAndSanitizersLength();
    error BarebonesManagerWithMerkleVerification__FailedToVerifyManageProof(
        address target, bytes targetData, uint256 value
    );
    error BarebonesManagerWithMerkleVerification__Paused();
    error BarebonesManagerWithMerkleVerification__OnlyCallableByBoringVault();
    error BarebonesManagerWithMerkleVerification__OnlyCallableByBalancerVault();
    error BarebonesManagerWithMerkleVerification__TotalSupplyMustRemainConstantDuringManagement();

    //============================== EVENTS ===============================

    event ManageRootUpdated(address indexed strategist, bytes32 oldRoot, bytes32 newRoot);
    event BoringVaultManaged(uint256 callsMade);
    event Paused();
    event Unpaused();

    //============================== IMMUTABLES ===============================

    /**
     * @notice The BoringVault this contract can manage.
     */
    BoringVault public immutable vault;

    constructor(address _owner, address _vault) Auth(_owner, Authority(address(0))) {
        vault = BoringVault(payable(_vault));
    }

    // ========================================= ADMIN FUNCTIONS =========================================

    /**
     * @notice Sets the manageRoot.
     * @dev Callable by OWNER_ROLE.
     */
    function setManageRoot(address strategist, bytes32 _manageRoot) external requiresAuth {
        bytes32 oldRoot = manageRoot[strategist];
        manageRoot[strategist] = _manageRoot;
        emit ManageRootUpdated(strategist, oldRoot, _manageRoot);
    }

    /**
     * @notice Pause this contract, which prevents future calls to `manageVaultWithMerkleVerification`.
     * @dev Callable by MULTISIG_ROLE.
     */
    function pause() external requiresAuth {
        isPaused = true;
        emit Paused();
    }

    /**
     * @notice Unpause this contract, which allows future calls to `manageVaultWithMerkleVerification`.
     * @dev Callable by MULTISIG_ROLE.
     */
    function unpause() external requiresAuth {
        isPaused = false;
        emit Unpaused();
    }

    // ========================================= STRATEGIST FUNCTIONS =========================================

    /**
     * @notice Allows strategist to manage the BoringVault.
     * @dev The strategist must provide a merkle proof for every call that verifiees they are allowed to make that call.
     * @dev Callable by MANAGER_INTERNAL_ROLE.
     * @dev Callable by STRATEGIST_ROLE.
     * @dev Callable by MICRO_MANAGER_ROLE.
     */
    function manageVaultWithMerkleVerification(
        bytes32[][] calldata manageProofs,
        address[] calldata decodersAndSanitizers,
        address[] calldata targets,
        bytes[] calldata targetData,
        uint256[] calldata values
    ) external requiresAuth {
        if (isPaused) revert BarebonesManagerWithMerkleVerification__Paused();
        uint256 targetsLength = targets.length;
        if (targetsLength != manageProofs.length) {
            revert BarebonesManagerWithMerkleVerification__InvalidManageProofLength();
        }
        if (targetsLength != targetData.length) {
            revert BarebonesManagerWithMerkleVerification__InvalidTargetDataLength();
        }
        if (targetsLength != values.length) revert BarebonesManagerWithMerkleVerification__InvalidValuesLength();
        if (targetsLength != decodersAndSanitizers.length) {
            revert BarebonesManagerWithMerkleVerification__InvalidDecodersAndSanitizersLength();
        }

        bytes32 strategistManageRoot = manageRoot[msg.sender];
        uint256 totalSupply = vault.totalSupply();

        for (uint256 i; i < targetsLength; ++i) {
            _verifyCallData(
                strategistManageRoot, manageProofs[i], decodersAndSanitizers[i], targets[i], values[i], targetData[i]
            );
            vault.manage(targets[i], targetData[i], values[i]);
        }
        if (totalSupply != vault.totalSupply()) {
            revert BarebonesManagerWithMerkleVerification__TotalSupplyMustRemainConstantDuringManagement();
        }
        emit BoringVaultManaged(targetsLength);
    }

    // ========================================= INTERNAL HELPER FUNCTIONS =========================================

    /**
     * @notice Helper function to decode, sanitize, and verify call data.
     */
    function _verifyCallData(
        bytes32 currentManageRoot,
        bytes32[] calldata manageProof,
        address decoderAndSanitizer,
        address target,
        uint256 value,
        bytes calldata targetData
    ) internal view {
        // Use address decoder to get addresses in call data.
        bytes memory packedArgumentAddresses = abi.decode(decoderAndSanitizer.functionStaticCall(targetData), (bytes));

        if (
            !_verifyManageProof(
                currentManageRoot,
                manageProof,
                target,
                decoderAndSanitizer,
                value,
                bytes4(targetData),
                packedArgumentAddresses
            )
        ) {
            revert BarebonesManagerWithMerkleVerification__FailedToVerifyManageProof(target, targetData, value);
        }
    }

    /**
     * @notice Helper function to verify a manageProof is valid.
     */
    function _verifyManageProof(
        bytes32 root,
        bytes32[] calldata proof,
        address target,
        address decoderAndSanitizer,
        uint256 value,
        bytes4 selector,
        bytes memory packedArgumentAddresses
    ) internal pure returns (bool) {
        bool valueNonZero = value > 0;
        bytes32 leaf =
            keccak256(abi.encodePacked(decoderAndSanitizer, target, valueNonZero, selector, packedArgumentAddresses));
        return MerkleProofLib.verify(proof, root, leaf);
    }
}
