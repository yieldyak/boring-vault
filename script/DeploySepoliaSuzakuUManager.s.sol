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

    address public managerAddress = 0x665D7b78f10A5693A335e9036d70622cC4305111;
    address public rawDataDecoderAndSanitizer = 0xF95Bb47300D90810Cf8f839b0352488475094f96;
    BoringVault public boringVault = BoringVault(payable(0x8F9e0408DCc0Dfe1Ca9c1A8620A78AaEF0561Fd9));
    ManagerWithMerkleVerification public manager =
        ManagerWithMerkleVerification(0x665D7b78f10A5693A335e9036d70622cC4305111);
    address public accountantAddress = 0x1eC5abe5A1789ba8e3E1f09b80C4065FD1767fbd;
    RolesAuthority public rolesAuthority;
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

        rolesAuthority = RolesAuthority(deployer.getAddress(SevenSeasRolesAuthorityName));
        setAddress(false, sepolia, "boringVault", address(boringVault));
        setAddress(false, sepolia, "managerAddress", managerAddress);
        setAddress(false, sepolia, "accountantAddress", accountantAddress);
        setAddress(false, sepolia, "rawDataDecoderAndSanitizer", rawDataDecoderAndSanitizer);


        ManageLeaf[] memory leafs = new ManageLeaf[](4);
        _addSuzakuApproveAndDepositLeaf(leafs, getAddress(sourceChain, "DC_btc.b"));
        _addSuzakuApproveAndDepositLeaf(leafs, getAddress(sourceChain, "DC_sAVAX"));

        string memory filePath = "./leafs/sepoliaSuzakuSniperLeafs.json";

        bytes32[][] memory merkleTree = _generateMerkleTree(leafs);

        _generateLeafs(filePath, leafs, merkleTree[merkleTree.length - 1][0], merkleTree);

        vm.startBroadcast(privateKey);

        suzakuUManager = new SuzakuUManager(
            getAddress(sourceChain, "dev0Address"), rolesAuthority, address(manager), address(boringVault)
        );

        console.log("SuzakuUManager deployed at:", address(suzakuUManager));
        console.log("Caller address:", msg.sender);
        console.log("RolesAuthority address:", address(rolesAuthority));

        // Assign the necessary role to the caller
        rolesAuthority.setUserRole(msg.sender, STRATEGIST_MULTISIG_ROLE, true);        

        suzakuUManager.updateMerkleTree(merkleTree, false);

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

        rolesAuthority.transferOwnership(getAddress(sourceChain, "dev1Address"));
        suzakuUManager.transferOwnership(getAddress(sourceChain, "dev1Address"));

        /// Note need to give strategist role to suzakuUManager
        /// Note need to set merkle root in the manager

        vm.stopBroadcast();
    }
}
