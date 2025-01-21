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
 *  source .env && forge script script/MerkleRootCreation/Avalanche/rsAVAX/CreateAvalancheSuzakuDCSniperMerkleRoot.s.sol:CreateAvalancheSuzakuDCSniperMerkleRoot --rpc-url $AVALANCHE_RPC_URL
 */
contract CreateAvalancheSuzakuDCSniperMerkleRoot is Script, MerkleTreeHelper {
    using FixedPointMathLib for uint256;

    address public boringVault = 0x2badd78b05C913f129f649627c4279dC60D478E1;
    address public managerAddress = 0x1cd8B25C620C0596c60149c7dE2dd3552569379D;
    address public accountantAddress = 0x93a309e0C8b20C764758b94f950Be8B1676fFb17;
    address public rawDataDecoderAndSanitizer = 0xe788464Cb0f70E2BB8D4B6995b255D8F4Ed32cC9;

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
        address defaultCollateral = getAddress(sourceChain, "DC_sAVAX");

        string memory filePath = "./leafs/avalanche_rsAVAX_suzaku_dc_sniper.json";

        (bytes32[][] memory manageTree, ManageLeaf[] memory leafs) = generateWithdrawOnlyTreeAndLeafs(defaultCollateral);

        _generateLeafs(filePath, leafs, manageTree[manageTree.length - 1][0], manageTree);
    }
}
