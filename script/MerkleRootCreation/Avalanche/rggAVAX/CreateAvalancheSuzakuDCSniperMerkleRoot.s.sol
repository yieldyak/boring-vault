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
 *  source .env && forge script script/MerkleRootCreation/Avalanche/rggAVAX/CreateAvalancheSuzakuDCSniperMerkleRoot.s.sol:CreateAvalancheSuzakuDCSniperMerkleRoot --rpc-url $AVALANCHE_RPC_URL
 */
contract CreateAvalancheSuzakuDCSniperMerkleRoot is Script, MerkleTreeHelper {
    using FixedPointMathLib for uint256;

    address public boringVault = 0x9D15A28fCB96AF5e26dd0EF546D6a777C0ec34cd;
    address public managerAddress = 0xDeEd5D9F3413406F388e1A80a8dCdDCA18298e02;
    address public accountantAddress = 0x46520834D24FBF4e556576a8BB29eB8500378561;
    address public rawDataDecoderAndSanitizer = 0xf543cEBe6476A3772da397427be116233fcD0255;

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
        address defaultCollateral = getAddress(sourceChain, "DC_ggAVAX");

        string memory filePath = "./leafs/avalanche_rggAVAX_suzaku_dc_sniper.json";

        (bytes32[][] memory manageTree, ManageLeaf[] memory leafs) = generateWithdrawOnlyTreeAndLeafs(defaultCollateral);

        _generateLeafs(filePath, leafs, manageTree[manageTree.length - 1][0], manageTree);
    }
}
