// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {Deployer} from "src/helper/Deployer.sol";
import {AvalancheAddresses} from "../AvalancheAddresses.sol";
import {MilkUSDAIDecoderAndSanitizer} from "../../../../src/base/DecodersAndSanitizers/MilkUSDAIDecoderAndSanitizer.sol";

import "forge-std/Script.sol";

/**
 *  forge script script/ArchitectureDeployments/Avalanche/yyAVAXai/RedeployUSDMilkAIDecoderAndSanitizer.s.sol:RedeployUSDMilkAIDecoderAndSanitizer --account yak-deployer --broadcast --verifier-url 'https://api.routescan.io/v2/network/mainnet/evm/43114/etherscan' --etherscan-api-key "verifyContract" --verify
 * @dev Optionally can change `--with-gas-price` to something more reasonable
 */
contract RedeployUSDMilkAIDecoderAndSanitizer is Script, AvalancheAddresses {
    address public boringVault = 0xdC038cFf8E55416a5189e37F382879c19217a4CB;

    function setUp() external {
        vm.createSelectFork("avalanche");
    }

    function run() external {
        vm.startBroadcast();

        new MilkUSDAIDecoderAndSanitizer(boringVault);

        vm.stopBroadcast();
    }
}