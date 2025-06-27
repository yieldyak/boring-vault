// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BenqiSAvaxRateProvider} from "../../../src/rate-providers/BenqiSAvaxRateProvider.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import "forge-std/Script.sol";

/**
 * source .env && forge script script/RateProviders/Avalanche/DeployBenqiSAvaxRateProvider.s.sol:DeployBenqiSAvaxRateProvider --account yak-deployer
 * source .env && forge script script/RateProviders/Avalanche/DeployBenqiSAvaxRateProvider.s.sol:DeployBenqiSAvaxRateProvider --account yak-deployer --slow --broadcast --verifier-url 'https://api.routescan.io/v2/network/mainnet/evm/43114/etherscan' --etherscan-api-key "verifyContract" --verify
 */
contract DeployBenqiSAvaxRateProvider is Script {
    address constant SAVAX = 0x2b2C81e08f1Af8835a78Bb2A90AE924ACE0eA4bE;
    function setUp() external {
        vm.createSelectFork("avalanche");
    }

    function run() external {
        vm.startBroadcast();

        BenqiSAvaxRateProvider rateProvider =
            new BenqiSAvaxRateProvider(SAVAX);

        console.log("BenqiSAvaxRateProvider deployed at:", address(rateProvider));
        vm.stopBroadcast();
    }
}
