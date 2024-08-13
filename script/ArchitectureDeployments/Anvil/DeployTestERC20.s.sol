// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {TestERC20} from "src/anvil/TestERC20.sol";

contract DeployTestERC20 is Script {
    function run() external returns (address) {
        vm.startBroadcast();

        // Fetch token details from environment variables
        string memory tokenName = vm.envString("TOKEN_NAME");
        string memory tokenSymbol = vm.envString("TOKEN_SYMBOL");
        uint256 initialSupply = vm.envUint("INITIAL_SUPPLY"); // Initial supply in wei

        // Deploy the TestERC20 contract with specified parameters
        TestERC20 testERC20 = new TestERC20(tokenName, tokenSymbol, msg.sender, initialSupply);

        vm.stopBroadcast();

        return address(testERC20);
    }
}
