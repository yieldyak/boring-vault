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

    address public boringVault = 0xD65deA0e72A2E0b321C360066a2BE8E8e16B3Ac6;
    address public managerAddress = 0x05E51F827cbA124e104a9A2F609B0Fb34d0F4D1E;
    address public accountantAddress = 0x58Ee67D878D3A095B074e6D6182F1fbB57F5f7F4;
    address public rawDataDecoderAndSanitizer = 0x9DfA103Bc4348D951a3FE54B393A261Ef5Ad1B03;

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
