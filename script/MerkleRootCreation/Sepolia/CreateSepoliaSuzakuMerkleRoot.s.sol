// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import {Strings} from "lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import {ERC4626} from "@solmate/tokens/ERC4626.sol";
import {ManagerWithMerkleVerification} from "src/base/Roles/ManagerWithMerkleVerification.sol";
import {MerkleTreeHelper} from "test/resources/MerkleTreeHelper/MerkleTreeHelper.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

/**
 *  source .env && forge script script/MerkleRootCreation/Sepolia/CreateSepoliaSuzakuMerkleRoot.s.sol:CreateSepoliaSuzakuMerkleRoot --rpc-url $SEPOLIA_RPC_URL
 */
contract CreateSepoliaSuzakuMerkleRoot is Script, MerkleTreeHelper {
    using FixedPointMathLib for uint256;

    address public boringVault = 0x11Ce42c6FE827f42BE7Bbb7BECBcc0E80A69880f;
    address public managerAddress = 0x478741b38BC8c721C525bcee5620Dd6ab9133519;
    address public accountantAddress =
        0x3DC53B40F03bc6A873f3E8A2eD1AecdA491cD32b;
    address public rawDataDecoderAndSanitizer =
        0x4Fb29DE25f853f0A4eb5d1dE45883D706D784488;

    function setUp() external {}

    /**
     * @notice Uncomment which script you want to run.
     */
    function run() external {
        /// NOTE Only have 1 function run at a time, otherwise the merkle root created will be wrong.
        generateAdminStrategistMerkleRoot();
        // generateSniperMerkleRoot();
    }

    function generateSniperMerkleRoot() public {
        setSourceChainName(sepolia);
        setAddress(false, sepolia, "boringVault", boringVault);
        setAddress(false, sepolia, "managerAddress", managerAddress);
        setAddress(false, sepolia, "accountantAddress", accountantAddress);
        setAddress(
            false,
            sepolia,
            "rawDataDecoderAndSanitizer",
            rawDataDecoderAndSanitizer
        );

        ManageLeaf[] memory leafs = new ManageLeaf[](4);
        leafIndex = type(uint256).max;
        _addSuzakuApproveAndDepositLeaf(
            leafs,
            getAddress(sourceChain, "DC_BTC.b")
        );
        // _addSuzakuApproveAndDepositLeaf(leafs, getAddress(sourceChain, "DC_sAVAX"));
        _addSuzakuApproveAndDepositLeaf(
            leafs,
            getAddress(sourceChain, "DC_BTC.b_vault_shares")
        );
        // _addSuzakuApproveAndDepositLeaf(leafs, getAddress(sourceChain, "DC_sAVAX_vault_shares"));

        string memory filePath = "./leafs/sepoliaSuzakuSniperLeafs.json";

        bytes32[][] memory manageTree = _generateMerkleTree(leafs);

        _generateLeafs(
            filePath,
            leafs,
            manageTree[manageTree.length - 1][0],
            manageTree
        );
    }

    function generateAdminStrategistMerkleRoot() public {
        setSourceChainName(sepolia);
        setAddress(false, sepolia, "boringVault", boringVault);
        setAddress(false, sepolia, "managerAddress", managerAddress);
        setAddress(false, sepolia, "accountantAddress", accountantAddress);
        setAddress(
            false,
            sepolia,
            "rawDataDecoderAndSanitizer",
            rawDataDecoderAndSanitizer
        );

        leafIndex = 0;

        ManageLeaf[] memory leafs = new ManageLeaf[](256);

        // ========================== Suzaku Collateral ==========================
        address[] memory defaultCollaterals = new address[](1);
        defaultCollaterals[0] = getAddress(sourceChain, "DC_BTC.b");
        // defaultCollaterals[1] = getAddress(sourceChain, "DC_sAVAX");
        _addSuzakuLeafs(leafs, defaultCollaterals);

        // ========================== Suzaku Vault ==========================
        address[] memory suzakuVaults = new address[](1);
        console.log(
            "DC_BTC.b_vault_shares:",
            getAddress(sourceChain, "DC_BTC.b_vault_shares")
        );
        suzakuVaults[0] = getAddress(sourceChain, "DC_BTC.b_vault_shares");
        // suzakuVaults[1] = getAddress(sourceChain, "DC_sAVAX_vault_shares");
        _addSuzakuVaultLeafs(leafs, suzakuVaults);

        string memory filePath = "./leafs/SuperSuzakuStrategistLeafs.json";

        bytes32[][] memory manageTree = _generateMerkleTree(leafs);

        _generateLeafs(
            filePath,
            leafs,
            manageTree[manageTree.length - 1][0],
            manageTree
        );
    }
}
