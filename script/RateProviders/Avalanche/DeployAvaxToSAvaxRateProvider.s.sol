// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {AvaxToSAvaxRateProvider} from "../../../src/rate-providers/AvaxToSAvaxRateProvider.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import {AvalancheAddresses} from "../../ArchitectureDeployments/Avalanche/AvalancheAddresses.sol";
import "forge-std/Script.sol";

/**
 * source .env && forge script script/RateProviders/Avalanche/DeployAvaxToSAvaxRateProvider.s.sol:DeployAvaxToSAvaxRateProvider --account deployer
 * source .env && forge script script/RateProviders/Avalanche/DeployAvaxToSAvaxRateProvider.s.sol:DeployAvaxToSAvaxRateProvider --account deployer --slow --broadcast --verifier-url 'https://api.routescan.io/v2/network/mainnet/evm/43114/etherscan' --etherscan-api-key "verifyContract" --verify
 */
contract DeployAvaxToSAvaxRateProvider is Script, AvalancheAddresses {
    function setUp() external {
        vm.createSelectFork("avalanche");
    }

    function run() external {
        vm.startBroadcast();

        AvaxToSAvaxRateProvider rateProvider = new AvaxToSAvaxRateProvider(address(sAVAX));

        console.log("AvaxToSAvaxRateProvider deployed at:", address(rateProvider));
        vm.stopBroadcast();
    }
}
