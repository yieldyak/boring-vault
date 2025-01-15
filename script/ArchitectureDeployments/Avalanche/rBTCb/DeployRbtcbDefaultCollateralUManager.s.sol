// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {BoringVault} from "src/base/BoringVault.sol";
import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import {Strings} from "lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import {ERC4626} from "@solmate/tokens/ERC4626.sol";
import {BarebonesManagerWithMerkleVerification} from "src/base/Roles/BarebonesManagerWithMerkleVerification.sol";
import {
    SuzakuDefaultCollateralUManager, DefaultCollateral
} from "src/micro-managers/SuzakuDefaultCollateralUManager.sol";
import {RolesAuthority, Authority} from "@solmate/auth/authorities/RolesAuthority.sol";
import {ContractNames} from "resources/ContractNames.sol";
import {Deployer} from "src/helper/Deployer.sol";
import {MerkleTreeHelper} from "test/resources/MerkleTreeHelper/MerkleTreeHelper.sol";
import {AvalancheAddresses} from "../AvalancheAddresses.sol";
import {Roles} from "../../Roles.sol";
import "forge-std/console.sol";
/**
 *  source .env && forge script script/ArchitectureDeployments/Avalanche/rBTCb/DeployRbtcbDefaultCollateralUManager.s.sol:DeployRbtcbDefaultCollateralUManager --slow --broadcast --verifier-url 'https://api.routescan.io/v2/network/mainnet/evm/43114/etherscan' --etherscan-api-key "verifyContract" --verify
 */

contract DeployRbtcbDefaultCollateralUManager is MerkleTreeHelper, ContractNames, AvalancheAddresses, Roles {
    using FixedPointMathLib for uint256;

    uint256 public privateKey;

    address public deployerContractAddress = 0x0000000000000000000000000000000000000000;
    address public managerAddress = 0x0000000000000000000000000000000000000000;
    address public rawDataDecoderAndSanitizer = 0x0000000000000000000000000000000000000000;
    BoringVault public boringVault = BoringVault(payable(0x0000000000000000000000000000000000000000));
    BarebonesManagerWithMerkleVerification public manager = BarebonesManagerWithMerkleVerification(managerAddress);
    address public accountantAddress = 0x0000000000000000000000000000000000000000;
    RolesAuthority public rolesAuthority;
    address public rolesAuthorities = 0x0000000000000000000000000000000000000000;
    address public sniperBot = 0x0000000000000000000000000000000000000000;
    SuzakuDefaultCollateralUManager public suzakuUManager;

    Deployer public deployer;

    uint96 public constant MIN_DEPOSIT = 1;

    function setUp() external {
        privateKey = vm.envUint("LIQUID_DEPLOYER");
        vm.createSelectFork("avalanche");
    }

    /**
     * @notice Uncomment which script you want to run.
     */
    function run() external {
        /// NOTE Only have 1 function run at a time, otherwise the merkle root created will be wrong.
        generateSniperMerkleRoot();
    }

    function generateSniperMerkleRoot() public {
        setSourceChainName(avalanche);
        console.log("Deployer address:", deployerContractAddress);
        deployer = Deployer(deployerContractAddress);

        // rolesAuthority = RolesAuthority(deployer.getAddress(SuzakuRolesAuthorityName));
        setAddress(false, avalanche, "boringVault", address(boringVault));
        setAddress(false, avalanche, "managerAddress", managerAddress);
        setAddress(false, avalanche, "accountantAddress", accountantAddress);
        setAddress(false, avalanche, "rawDataDecoderAndSanitizer", rawDataDecoderAndSanitizer);
        setAddress(false, avalanche, "rolesAuthority", rolesAuthorities);

        ManageLeaf[] memory leafs = new ManageLeaf[](2);
        _addSuzakuApproveAndDepositLeaf(leafs, getAddress(sourceChain, "DC_BTCb"));

        string memory filePath = "./leafs/avalanche_rsBTCb_suzaku_dc_manager_internal.json";

        bytes32[][] memory merkleTree = _generateMerkleTree(leafs);

        _generateLeafs(filePath, leafs, merkleTree[merkleTree.length - 1][0], merkleTree);

        vm.startBroadcast(privateKey);

        rolesAuthority = RolesAuthority(rolesAuthorities);

        suzakuUManager = new SuzakuDefaultCollateralUManager(
            getAddress(sourceChain, "dev0Address"), rolesAuthority, address(manager), address(boringVault)
        );

        rolesAuthority.setUserRole(address(suzakuUManager), MANAGER_INTERNAL_ROLE, true);

        console.log("SuzakuDefaultCollateralUManager deployed at:", address(suzakuUManager));
        console.log("Caller address:", msg.sender);
        console.log("RolesAuthority address:", address(rolesAuthority));
        console.log("Merkle tree length:", merkleTree.length);

        // suzakuUManager.updateMerkleTree(merkleTree, false);
        try suzakuUManager.updateMerkleTree(merkleTree, false) {
            console.log("Merkle tree updated successfully");
        } catch Error(string memory reason) {
            console.log("Error updating merkle tree:", reason);
        } catch {
            console.log("Low-level error updating merkle tree");
        }

        suzakuUManager.setConfiguration(
            DefaultCollateral(getAddress(sourceChain, "DC_BTCb")), MIN_DEPOSIT, rawDataDecoderAndSanitizer
        );

        rolesAuthority.setRoleCapability(
            STRATEGIST_MULTISIG_ROLE,
            address(suzakuUManager),
            SuzakuDefaultCollateralUManager.updateMerkleTree.selector,
            true // Gives the strategist multisig the ability to update the merkle tree
        );
        rolesAuthority.setRoleCapability(
            STRATEGIST_MULTISIG_ROLE,
            address(suzakuUManager),
            SuzakuDefaultCollateralUManager.setConfiguration.selector,
            true // Gives the strategist multisig the ability to set the configuration
        );
        rolesAuthority.setRoleCapability(
            SNIPER_ROLE,
            address(suzakuUManager),
            SuzakuDefaultCollateralUManager.assemble.selector,
            true // Gives the sniper the ability to assemble
        );
        rolesAuthority.setRoleCapability(
            SNIPER_ROLE,
            address(suzakuUManager),
            SuzakuDefaultCollateralUManager.fullAssemble.selector,
            true // Gives the sniper the ability to full assemble
        );
        rolesAuthority.setRoleCapability(
            SNIPER_ROLE,
            address(managerAddress),
            BarebonesManagerWithMerkleVerification.manageVaultWithMerkleVerification.selector,
            true // Gives the sniper the ability to manage the vault with merkle verification
        );

        if (sniperBot > address(0) && !rolesAuthority.doesUserHaveRole(sniperBot, SNIPER_ROLE)) {
            rolesAuthority.setUserRole(sniperBot, SNIPER_ROLE, true);
            console.log("SNIPER ROLE granted to ", sniperBot);
        }

        if (suzakuUManager.owner() != address(0)) suzakuUManager.transferOwnership(address(0));
        if (rolesAuthority.owner() != teamMultisig) rolesAuthority.transferOwnership(teamMultisig);

        console.log(
            "This script generated './leafs/avalanche_rsBTCb_suzaku_dc_manager_internal.json', but did not set the manage root for the deployed uManager!"
        );

        vm.stopBroadcast();
    }
}
