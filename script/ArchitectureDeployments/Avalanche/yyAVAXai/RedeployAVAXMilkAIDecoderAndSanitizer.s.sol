// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {Deployer} from "src/helper/Deployer.sol";
import {AvalancheAddresses} from "../AvalancheAddresses.sol";
import {MilkAvaxAIDecoderAndSanitizer} from "../../../../src/base/DecodersAndSanitizers/MilkAvaxAIDecoderAndSanitizer.sol";

import "forge-std/Script.sol";

/**
 *  source .env && forge script script/ArchitectureDeployments/Avalanche/yyAVAXai/RedeployAVAXMilkAIDecoderAndSanitizer.s.sol:RedeployAVAXMilkAIDecoderAndSanitizer --broadcast --verifier-url 'https://api.routescan.io/v2/network/mainnet/evm/43114/etherscan' --etherscan-api-key "verifyContract" --verify
 * @dev Optionally can change `--with-gas-price` to something more reasonable
 */
contract RedeployAVAXMilkAIDecoderAndSanitizer is Script, AvalancheAddresses {
    uint256 public privateKey;

    address public boringVault = 0xa845Cbe370B99AdDaB67AfE442F2cF5784d4dC29;

    function setUp() external {
        privateKey = vm.envUint("LIQUID_DEPLOYER");
        vm.createSelectFork("avalanche");
    }

    function run() external {
        vm.startBroadcast(privateKey);

        new MilkAvaxAIDecoderAndSanitizer(boringVault);

        vm.stopBroadcast();
    }
}