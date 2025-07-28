// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {Deployer} from "src/helper/Deployer.sol";
import {RolesAuthority, Authority} from "@solmate/auth/authorities/RolesAuthority.sol";
import {ContractNames} from "resources/ContractNames.sol";
import {AvalancheAddresses} from "../AvalancheAddresses.sol";

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";

/**
 * source .env && forge script script/ArchitectureDeployments/Avalanche/yyUSDai/DeployUSDMilkAIDeployer.s.sol:DeployUSDMilkAIDeployer --account yak-deployer
 * forge script script/ArchitectureDeployments/Avalanche/yyUSDai/DeployUSDMilkAIDeployer.s.sol:DeployUSDMilkAIDeployer --account yak-deployer --slow --broadcast --verifier-url 'https://api.routescan.io/v2/network/mainnet/evm/43114/etherscan' --etherscan-api-key "verifyContract" --verify
 * @dev Optionally can change `--with-gas-price` to something more reasonable
 */
contract DeployUSDMilkAIDeployer is Script, ContractNames, AvalancheAddresses {

    // Contracts to deploy
    RolesAuthority public rolesAuthority;
    Deployer public deployer;

    uint8 public DEPLOYER_ROLE = 1;

    function setUp() external {
        vm.createSelectFork("avalanche");
    }

    function run() external {
        bytes memory creationCode;
        bytes memory constructorArgs;
        vm.startBroadcast();

        deployer = new Deployer(dev0Address, Authority(address(0)));
        creationCode = type(RolesAuthority).creationCode;
        constructorArgs = abi.encode(dev0Address, Authority(address(0)));
        rolesAuthority = RolesAuthority(
            deployer.deployContract(DeployerContractRolesAuthorityName, creationCode, constructorArgs, 0)
        );

        deployer.setAuthority(rolesAuthority);

        rolesAuthority.setRoleCapability(DEPLOYER_ROLE, address(deployer), Deployer.deployContract.selector, true);
        rolesAuthority.setUserRole(dev0Address, DEPLOYER_ROLE, true);

        vm.stopBroadcast();
    }
}
