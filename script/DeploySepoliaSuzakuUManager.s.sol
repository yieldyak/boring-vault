// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {BoringVault} from "src/base/BoringVault.sol";
import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import {Strings} from "lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import {ERC4626} from "@solmate/tokens/ERC4626.sol";
import {ManagerWithMerkleVerification} from "src/base/Roles/ManagerWithMerkleVerification.sol";
import {
    SuzakuDefaultCollateralUManager, DefaultCollateral
} from "src/micro-managers/SuzakuDefaultCollateralUManager.sol";
import {RolesAuthority, Authority} from "@solmate/auth/authorities/RolesAuthority.sol";
import {ContractNames} from "resources/ContractNames.sol";
import {Deployer} from "src/helper/Deployer.sol";
import {MerkleTreeHelper} from "test/resources/MerkleTreeHelper/MerkleTreeHelper.sol";
import "forge-std/console.sol";
/**
 *  source .env && forge script script/DeploySepliaSuzakuUManager.s.sol:DeploySepliaSuzakuUManagerScript --with-gas-price 10000000000 --slow --broadcast --etherscan-api-key $ETHERSCAN_API_KEY --verify
 */

contract DeploySepliaSuzakuUManagerScript is MerkleTreeHelper, ContractNames {
    using FixedPointMathLib for uint256;

    uint256 public privateKey;

    address public managerAddress = 0x2C0972ee4fa7d629462f63C844E9D7059CbD95Aa;
    address public rawDataDecoderAndSanitizer = 0x42A342D1B3bB7AD9143FAF2378ec2e3D6F764105;
    BoringVault public boringVault = BoringVault(payable(0xe5A67Bb6335d73b3c9286eFD21b3d9eb1a8AE8C0));
    ManagerWithMerkleVerification public manager = ManagerWithMerkleVerification(managerAddress);
    address public accountantAddress = 0xfDb93132F12c9587a06b1dF859187a7ca435A5bD;
    RolesAuthority public rolesAuthority;
    address public rolesAuthorities = 0x901B87B0Df4dcdE0DdFf439bE9d2BD57379f0E50;
    SuzakuDefaultCollateralUManager public suzakuUManager;

    Deployer public deployer;

    uint8 public constant STRATEGIST_MULTISIG_ROLE = 10;
    uint8 public constant SNIPER_ROLE = 88;

    function setUp() external {
        privateKey = vm.envUint("LIQUID_DEPLOYER");
        vm.createSelectFork("sepolia");
    }

    /**
     * @notice Uncomment which script you want to run.
     */
    function run() external {
        /// NOTE Only have 1 function run at a time, otherwise the merkle root created will be wrong.
        generateSniperMerkleRoot();
    }

    function generateSniperMerkleRoot() public {
        setSourceChainName(sepolia);
        console.log("Deployer address:", getAddress(sourceChain, "deployerAddress"));
        deployer = Deployer(getAddress(sourceChain, "deployerAddress"));

        // rolesAuthority = RolesAuthority(deployer.getAddress(SuzakuRolesAuthorityName));
        setAddress(false, sepolia, "boringVault", address(boringVault));
        setAddress(false, sepolia, "managerAddress", managerAddress);
        setAddress(false, sepolia, "accountantAddress", accountantAddress);
        setAddress(false, sepolia, "rawDataDecoderAndSanitizer", rawDataDecoderAndSanitizer);
        setAddress(false, sepolia, "rolesAuthority", rolesAuthorities);

        ManageLeaf[] memory leafs = new ManageLeaf[](2);
        _addSuzakuApproveAndDepositLeaf(leafs, getAddress(sourceChain, "DC_BTC.b"));
        // _addSuzakuApproveAndDepositLeaf(leafs, getAddress(sourceChain, "DC_sAVAX"));

        string memory filePath = "./leafs/sepoliaSuzakuSniperLeafs.json";

        bytes32[][] memory merkleTree = _generateMerkleTree(leafs);

        _generateLeafs(filePath, leafs, merkleTree[merkleTree.length - 1][0], merkleTree);

        vm.startBroadcast(privateKey);

        rolesAuthority = RolesAuthority(rolesAuthorities);

        suzakuUManager = new SuzakuDefaultCollateralUManager(
            getAddress(sourceChain, "dev0Address"), rolesAuthority, address(manager), address(boringVault)
        );

        console.log("SuzakuDefaultCollateralUManager deployed at:", address(suzakuUManager));
        console.log("Caller address:", msg.sender);
        console.log("RolesAuthority address:", address(rolesAuthority));
        // console.log("Merkle tree root:", merkleTree[merkleTree.length - 1][0]);
        console.log("Merkle tree length:", merkleTree.length);

        // Assign the necessary role to the caller

        if (!rolesAuthority.doesUserHaveRole(getAddress(sourceChain, "dev1Address"), STRATEGIST_MULTISIG_ROLE)) {
            rolesAuthority.setUserRole(getAddress(sourceChain, "dev1Address"), STRATEGIST_MULTISIG_ROLE, true);
        }

        // suzakuUManager.updateMerkleTree(merkleTree, false);
        try suzakuUManager.updateMerkleTree(merkleTree, false) {
            console.log("Merkle tree updated successfully");
        } catch Error(string memory reason) {
            console.log("Error updating merkle tree:", reason);
        } catch {
            console.log("Low-level error updating merkle tree");
        }

        suzakuUManager.setConfiguration(
            DefaultCollateral(getAddress(sourceChain, "DC_BTC.b")), 1e18, rawDataDecoderAndSanitizer
        );
        // suzakuUManager.setConfiguration(
        //     DefaultCollateral(getAddress(sourceChain, "DC_sAVAX")), 1e18, rawDataDecoderAndSanitizer
        // );

        rolesAuthority.setUserRole(address(suzakuUManager), 88, true); // Gives suzakuUmanager the SNIPER_ROLE

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
            ManagerWithMerkleVerification.manageVaultWithMerkleVerification.selector,
            true // Gives the sniper the ability to manage the vault with merkle verification
        );

        // rolesAuthority.transferOwnership(getAddress(sourceChain, "dev1Address"));
        // suzakuUManager.transferOwnership(getAddress(sourceChain, "dev1Address"));

        /// Note need to give strategist role to suzakuUManager DONE. Changed to use roleauth already deployed
        /// Note need to set merkle root in the manager THIS IS MISSING

        // rolesAuthority.setUserRole(dev1Address, 7, true);
        // rolesAuthority.setUserRole(dev1Address, 8, true);
        // ManagerWithMerkleVerification(managerAddress).setManageRoot(address(suzakuUManager), manageTree[manageTree.length - 1][0]); // Have to do manually for the moment, or add manageTree to the script.

        vm.stopBroadcast();
    }
}
