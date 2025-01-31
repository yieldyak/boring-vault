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

    address public boringVault = 0xe684F692bdf5B3B0DB7E8e31a276DE8A2E9F0025;
    address public managerAddress = 0x4CDF59d0ed892AF5eBdbF5fBD73A3D1406098FF4;
    address public accountantAddress = 0x57392E941a72cA47097135b9567C2c9Da8B2E0Fc;
    address public rawDataDecoderAndSanitizer = 0x7e2317C0701859c04A85fAD022EDE8f755fab180;

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
