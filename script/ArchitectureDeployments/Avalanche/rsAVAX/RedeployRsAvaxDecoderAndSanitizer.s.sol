// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {Deployer} from "src/helper/Deployer.sol";
import {AvalancheAddresses} from "../AvalancheAddresses.sol";
import {RsAvaxDecoderAndSanitizer} from "../../../../src/base/DecodersAndSanitizers/RsAvaxDecoderAndSanitizer.sol";

import "forge-std/Script.sol";

/**
 *  forge script script/ArchitectureDeployments/Avalanche/rsAVAX/RedeployRsAvaxDecoderAndSanitizer.s.sol:RedeployRsAvaxDecoderAndSanitizer --account deployer --broadcast --verifier-url 'https://api.routescan.io/v2/network/mainnet/evm/43114/etherscan' --etherscan-api-key "verifyContract" --verify
 * @dev Optionally can change `--with-gas-price` to something more reasonable
 */
contract RedeployRsAvaxDecoderAndSanitizer is Script, AvalancheAddresses {
    address public boringVault = 0xDf788AD40181894dA035B827cDF55C523bf52F67;

    function setUp() external {
        vm.createSelectFork("avalanche");
    }

    function run() external {
        vm.startBroadcast();

        new RsAvaxDecoderAndSanitizer(boringVault);

        vm.stopBroadcast();
    }
}
