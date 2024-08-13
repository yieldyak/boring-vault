// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {ERC20} from "@solmate/tokens/ERC20.sol";

contract SepoliaAddresses {
    // Liquid Ecosystem
    // address public deployerAddress = ;//  Used to deploy deployer contract. Added after DeployDeployer is deployed 0x07f20C12C16915C50134cB6B5eD921742F79F2cC
    // address public dev0Address = ; // Authority contract. Will be used for deploying contracts and managing them.
    // address public dev1Address = ; // Not used much currently.
    // address public liquidPayoutAddress = ; // Not used much currently

    // DeFi Ecosystem
    address public ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    // address public uniV3Router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    // address public uniV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public uniswapV3NonFungiblePositionManager = 0x655C406EBFa14EE2006250925e54ec43AD184f8B;

    ERC20 public BTCb = ERC20(0x64Db7fAC414cbd3754Ce02f92533eFf58134f518);
    ERC20 public WAVAX = ERC20(0xC5B8BEd342903aD9cEe6A31a212910D5cB8b4b9F);
    ERC20 public WETH = ERC20(0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9);


    address public balancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
}
