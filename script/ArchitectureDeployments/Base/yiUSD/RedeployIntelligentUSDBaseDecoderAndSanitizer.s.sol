// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {BaseAddresses} from "../BaseAddresses.sol";
import {
    IntelligentUSDBaseDecoderAndSanitizer
} from "src/base/DecodersAndSanitizers/IntelligentUSDBaseDecoderAndSanitizer.sol";

import "forge-std/Script.sol";

/**
 *  forge script script/ArchitectureDeployments/Base/yiUSD/RedeployIntelligentUSDBaseDecoderAndSanitizer.s.sol:RedeployIntelligentUSDBaseDecoderAndSanitizer --account deployer --broadcast --verify --retries 20 --delay 15 --verifier etherscan
 * @dev Optionally can change `--with-gas-price` to something more reasonable
 */
contract RedeployIntelligentUSDBaseDecoderAndSanitizer is Script, BaseAddresses {
    address public boringVault = 0xB5803023B8fa8BFe7d64E373297dFaA24e3B5962;

    function setUp() external {
        vm.createSelectFork("base");
    }

    function run() external {
        vm.startBroadcast();

        new IntelligentUSDBaseDecoderAndSanitizer(boringVault, velodromeNonFungiblePositionManager);

        vm.stopBroadcast();
    }
}
