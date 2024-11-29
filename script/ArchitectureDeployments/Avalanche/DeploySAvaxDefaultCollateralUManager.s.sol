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
import "forge-std/console.sol";
/**
 *  source .env && forge script script/ArchitectureDeployments/Avalanche/DeploySAvaxDefaultCollateralUManager.s.sol:DeploySAvaxDefaultCollateralUManager --slow --broadcast --verifier-url 'https://api.routescan.io/v2/network/mainnet/evm/43114/etherscan' --etherscan-api-key "verifyContract" --verify
 */

contract DeploySAvaxDefaultCollateralUManager is MerkleTreeHelper, ContractNames {
    using FixedPointMathLib for uint256;

    uint256 public privateKey;

    address public managerAddress = 0x1cd8B25C620C0596c60149c7dE2dd3552569379D;
    address public rawDataDecoderAndSanitizer = 0xe788464Cb0f70E2BB8D4B6995b255D8F4Ed32cC9;
    BoringVault public boringVault = BoringVault(payable(0x2badd78b05C913f129f649627c4279dC60D478E1));
    BarebonesManagerWithMerkleVerification public manager = BarebonesManagerWithMerkleVerification(managerAddress);
    address public accountantAddress = 0x93a309e0C8b20C764758b94f950Be8B1676fFb17;
    RolesAuthority public rolesAuthority;
    address public rolesAuthorities = 0x01fB02A17c05a2c793Aadb6f269a615Ea2A7b226;
    SuzakuDefaultCollateralUManager public suzakuUManager;

    Deployer public deployer;

    uint8 public constant STRATEGIST_MULTISIG_ROLE = 10;
    uint8 public constant SNIPER_ROLE = 88;

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
        console.log("Deployer address:", getAddress(sourceChain, "deployerAddress"));
        deployer = Deployer(getAddress(sourceChain, "deployerAddress"));

        // rolesAuthority = RolesAuthority(deployer.getAddress(SuzakuRolesAuthorityName));
        setAddress(false, avalanche, "boringVault", address(boringVault));
        setAddress(false, avalanche, "managerAddress", managerAddress);
        setAddress(false, avalanche, "accountantAddress", accountantAddress);
        setAddress(false, avalanche, "rawDataDecoderAndSanitizer", rawDataDecoderAndSanitizer);
        setAddress(false, avalanche, "rolesAuthority", rolesAuthorities);

        ManageLeaf[] memory leafs = new ManageLeaf[](2);
        _addSuzakuApproveAndDepositLeaf(leafs, getAddress(sourceChain, "DC_sAVAX"));

        string memory filePath = "./leafs/avalancheSuzakuSAVAXSniperLeafs.json";

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
            DefaultCollateral(getAddress(sourceChain, "DC_sAVAX")), 1e18, rawDataDecoderAndSanitizer
        );

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
            BarebonesManagerWithMerkleVerification.manageVaultWithMerkleVerification.selector,
            true // Gives the sniper the ability to manage the vault with merkle verification
        );

        /// Note need to set merkle root in the manager THIS IS MISSING

        // rolesAuthority.setUserRole(dev1Address, 7, true);
        // rolesAuthority.setUserRole(dev1Address, 8, true);
        // BarebonesManagerWithMerkleVerification(managerAddress).setManageRoot(address(suzakuUManager), manageTree[manageTree.length - 1][0]); // Have to do manually for the moment, or add manageTree to the script.

        vm.stopBroadcast();
    }
}
