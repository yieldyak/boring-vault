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
 *  source .env && forge script script/MerkleRootCreation/Avalanche/rBTCb/CreateAvalancheSuzakuDCSniperMerkleRoot.s.sol:CreateAvalancheSuzakuDCSniperMerkleRoot --rpc-url $AVALANCHE_RPC_URL
 */
contract CreateAvalancheSuzakuDCSniperMerkleRoot is Script, MerkleTreeHelper {
    using FixedPointMathLib for uint256;

    address public boringVault = 0x07714f9A17a926615B52C109346F6bE7d5E977b4;
    address public managerAddress = 0xFb7594706Ed392b115682f585154717f3575c6Ae;
    address public accountantAddress = 0xd65187e54d40eCD8619Ec7319560B68fE305256a;
    address public rawDataDecoderAndSanitizer = 0x5E6909269eAF878E35DfF895672E0a50F79ECEFA;

    function setUp() external {}

    /**
     * @notice Uncomment which script you want to run.
     */
    function run() external {
        setSourceChainName(avalanche);
        setAddress(false, avalanche, "boringVault", boringVault);
        setAddress(false, avalanche, "managerAddress", managerAddress);
        setAddress(false, avalanche, "accountantAddress", accountantAddress);
        setAddress(false, avalanche, "rawDataDecoderAndSanitizer", rawDataDecoderAndSanitizer);

        // ========================== Suzaku Collateral ==========================
        address defaultCollateral = getAddress(sourceChain, "DC_BTCb");

        string memory filePath = "./leafs/avalanche_rBTCb_suzaku_dc_sniper.json";

        (bytes32[][] memory manageTree, ManageLeaf[] memory leafs) = generateWithdrawOnlyTreeAndLeafs(defaultCollateral);

        _generateLeafs(filePath, leafs, manageTree[manageTree.length - 1][0], manageTree);
    }
}
