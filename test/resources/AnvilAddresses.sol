// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {ERC20} from "@solmate/tokens/ERC20.sol";

contract AnvilAddresses {
    // Liquid Ecosystem
    address public deployerAddress = 0x057ef64E23666F000b34aE31332854aCBd1c8544; // Replace with actual deployer address adter DeployDeployer has been launched
    address public dev0Address = 0x90F79bf6EB2c4f870365E785982E1f101E93b906;
    address public dev1Address = 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65;
    address public liquidPayoutAddress = 0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc;

    // DeFi Ecosystem
    address public ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    // address public uniV3Router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    // address public uniV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public uniswapV3NonFungiblePositionManager = 0x655C406EBFa14EE2006250925e54ec43AD184f8B;

    // Tokens to be created through DeployTestERC20.s.sol and addresses to be updated here
    // ERC20 public WAVAX = ERC20();
    // ERC20 public BTCb = ERC20();

    address public balancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
}
