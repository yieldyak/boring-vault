// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {YakMilkRsAvaxRateProvider} from "../../../src/rate-providers/YakMilkRsAvaxRateProvider.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import "forge-std/Script.sol";

/**
 * source .env && forge script script/RateProviders/Avalanche/DeployYakMilkRsAvaxRateProvider.s.sol:DeployYakMilkRsAvaxRateProvider --account yak-deployer
 * source .env && forge script script/RateProviders/Avalanche/DeployYakMilkRsAvaxRateProvider.s.sol:DeployYakMilkRsAvaxRateProvider --account yak-deployer --slow --broadcast --verifier-url 'https://api.routescan.io/v2/network/mainnet/evm/43114/etherscan' --etherscan-api-key "verifyContract" --verify
 */
contract DeployYakMilkRsAvaxRateProvider is Script {
    address constant BENQI_PROVIDER = 0x0BB342B4011e06907192D3C6E7131Ec792209794;
    address constant YAK_MILK_ACCOUNTANT = 0xA8d0c29cF475dD91Fe043D376bEFDDeEC2d2e24A;

    function setUp() external {
        vm.createSelectFork("avalanche");
    }

    function run() external {
        vm.startBroadcast();

        YakMilkRsAvaxRateProvider rateProvider =
            new YakMilkRsAvaxRateProvider(BENQI_PROVIDER, YAK_MILK_ACCOUNTANT);

        console.log("YakMilkRsAvaxRateProvider deployed at:", address(rateProvider));
        vm.stopBroadcast();
    }
}
