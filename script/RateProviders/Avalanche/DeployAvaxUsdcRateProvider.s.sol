// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {ChainlinkUsdcRateProvider} from "../../../src/rate-providers/ChainlinkUsdcRateProvider.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import "forge-std/Script.sol";

/**
 * source .env && forge script script/RateProviders/Avalanche/DeployAvaxUsdcRateProvider.s.sol:DeployAvaxUsdcRateProvider --slow --broadcast --verifier-url 'https://api.routescan.io/v2/network/mainnet/evm/43114/etherscan' --etherscan-api-key "verifyContract" --verify
 */
contract DeployAvaxUsdcRateProvider is Script {
    address constant AVAX_USD_FEED = 0x0A77230d17318075983913bC2145DB16C7366156;
    address constant USDC_USD_FEED = 0xF096872672F44d6EBA71458D74fe67F9a77a23B9;
    address constant WAVAX = 0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7;
    uint8 constant TARGET_DECIMALS = 18;

    uint256 public privateKey;

    function setUp() external {
        privateKey = vm.envUint("LIQUID_DEPLOYER");
        vm.createSelectFork("avalanche");
    }

    function run() external {
        vm.startBroadcast(privateKey);

        ChainlinkUsdcRateProvider rateProvider =
            new ChainlinkUsdcRateProvider(AVAX_USD_FEED, USDC_USD_FEED, TARGET_DECIMALS);

        console.log("ChainlinkUsdcRateProvider deployed at:", address(rateProvider));
        vm.stopBroadcast();
    }
}
