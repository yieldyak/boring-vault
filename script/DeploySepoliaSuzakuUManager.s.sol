// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {BoringVault} from "src/base/BoringVault.sol";
import {FixedPointMathLib} from "@solmate/utils/FixedPointMathLib.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import {Strings} from "lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import {ERC4626} from "@solmate/tokens/ERC4626.sol";
import {ManagerWithMerkleVerification} from "src/base/Roles/ManagerWithMerkleVerification.sol";
import {SuzakuUManager, DefaultCollateral} from "src/micro-managers/SuzakuUManager.sol";
import {RolesAuthority, Authority} from "@solmate/auth/authorities/RolesAuthority.sol";
import {ContractNames} from "resources/ContractNames.sol";
import {Deployer} from "src/helper/Deployer.sol";
import {MerkleTreeHelper} from "test/resources/MerkleTreeHelper/MerkleTreeHelper.sol";
import "forge-std/console.sol";
/**
 *  source .env && forge script script/DeploySepliaSuzakuUManager.s.sol:DeploySepliaSuzakuUManagerScript --with-gas-price 10000000000 --slow --broadcast --etherscan-api-key $ETHERSCAN_KEY --verify
 */
contract DeploySepliaSuzakuUManagerScript is MerkleTreeHelper, ContractNames {
    using FixedPointMathLib for uint256;

    uint256 public privateKey;

    address public managerAddress = 0x478741b38BC8c721C525bcee5620Dd6ab9133519;
    address public rawDataDecoderAndSanitizer = 0x85296ce2381922e4A0826b16f812FF7E43F36717;
    BoringVault public boringVault = BoringVault(payable(0x11Ce42c6FE827f42BE7Bbb7BECBcc0E80A69880f));
    ManagerWithMerkleVerification public manager =
        ManagerWithMerkleVerification(0x478741b38BC8c721C525bcee5620Dd6ab9133519);
    address public accountantAddress = 0x3DC53B40F03bc6A873f3E8A2eD1AecdA491cD32b;
    RolesAuthority public rolesAuthority;
    address public rolesAuthorities = 0x13D7bb576BB5e8781d6243c08302e71DbeE1ee92;
    SuzakuUManager public suzakuUManager;

    Deployer public deployer;

    uint8 public constant STRATEGIST_MULTISIG_ROLE = 10;
    uint8 public constant SNIPER_ROLE = 88;

    function setUp() external {
        privateKey = vm.envUint("ETHERFI_LIQUID_DEPLOYER");
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

        // rolesAuthority = RolesAuthority(deployer.getAddress(SevenSeasRolesAuthorityName));
        setAddress(false, sepolia, "boringVault", address(boringVault));
        setAddress(false, sepolia, "managerAddress", managerAddress);
        setAddress(false, sepolia, "accountantAddress", accountantAddress);
        setAddress(false, sepolia, "rawDataDecoderAndSanitizer", rawDataDecoderAndSanitizer);
        setAddress(false, sepolia, "rolesAuthority", rolesAuthorities);

        ManageLeaf[] memory leafs = new ManageLeaf[](2);
        _addSuzakuApproveAndDepositLeaf(leafs, getAddress(sourceChain, "DC_btc.b"));
        // _addSuzakuApproveAndDepositLeaf(leafs, getAddress(sourceChain, "DC_sAVAX"));

        string memory filePath = "./leafs/sepoliaSuzakuSniperLeafs.json";

        bytes32[][] memory merkleTree = _generateMerkleTree(leafs);

        _generateLeafs(filePath, leafs, merkleTree[merkleTree.length - 1][0], merkleTree); // wasn't created???

        vm.startBroadcast(privateKey);

        rolesAuthority = RolesAuthority(rolesAuthorities);

        suzakuUManager = new SuzakuUManager(
            getAddress(sourceChain, "dev0Address"), rolesAuthority, address(manager), address(boringVault)
        );

        console.log("SuzakuUManager deployed at:", address(suzakuUManager));
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
            DefaultCollateral(getAddress(sourceChain, "DC_btc.b")), 1e18, rawDataDecoderAndSanitizer
        );
        // suzakuUManager.setConfiguration(
        //     DefaultCollateral(getAddress(sourceChain, "DC_sAVAX")), 1e18, rawDataDecoderAndSanitizer
        // );

        rolesAuthority.setRoleCapability(
            STRATEGIST_MULTISIG_ROLE, address(suzakuUManager), SuzakuUManager.updateMerkleTree.selector, true
        );
        rolesAuthority.setRoleCapability(
            STRATEGIST_MULTISIG_ROLE, address(suzakuUManager), SuzakuUManager.setConfiguration.selector, true
        );
        rolesAuthority.setRoleCapability(
            SNIPER_ROLE, address(suzakuUManager), SuzakuUManager.assemble.selector, true
        );
        rolesAuthority.setRoleCapability(
            SNIPER_ROLE, address(suzakuUManager), SuzakuUManager.fullAssemble.selector, true
        );
        rolesAuthority.setRoleCapability(
            SNIPER_ROLE, address(suzakuUManager), ManagerWithMerkleVerification.manageVaultWithMerkleVerification.selector, true
        );

        // rolesAuthority.transferOwnership(getAddress(sourceChain, "dev1Address")); //why tho
        suzakuUManager.transferOwnership(getAddress(sourceChain, "dev1Address"));

        /// Note need to give strategist role to suzakuUManager DONE. Changed to use roleauth already deployed
        /// Note need to set merkle root in the manager THIS IS MISSING

        // rolesAuthority.setUserRole(dev1Address, 7, true);
        // rolesAuthority.setUserRole(dev1Address, 8, true);
        // ManagerWithMerkleVerification(managerAddress).setManageRoot(address(suzakuUManager), manageTree[manageTree.length - 1][0]); // done manually

        vm.stopBroadcast();
    }
}
