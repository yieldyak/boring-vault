// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {ERC20} from "@solmate/tokens/ERC20.sol";

contract SepoliaAddresses {
    // Liquid Ecosystem
    address public deployerAddress = 0x0; //  Used to deploy deployer contract. Added after DeployDeployer is deployed 0x07f20C12C16915C50134cB6B5eD921742F79F2cC
    address public dev0Address = 0x0691D2A17B46608a0B5A926a5a511E773f9bA036; // Authority contract. Will be used for deploying contracts and managing them.
    address public dev1Address = 0x0691D2A17B46608a0B5A926a5a511E773f9bA036; // Not used much currently.
    address public liquidPayoutAddress =
        0x0691D2A17B46608a0B5A926a5a511E773f9bA036; // Not used much currently

    // DeFi Ecosystem
    address public ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    // address public uniV3Router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    // address public uniV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public uniswapV3NonFungiblePositionManager =
        0x655C406EBFa14EE2006250925e54ec43AD184f8B;

    ERC20 public BTCb = ERC20(0x5f6887dc1cb759c47bd435448f7702209efb6c09);
    ERC20 public sAVAX = ERC20(0x85d6d9e0d5721eb32eed28429e89a85f2148713b);
    ERC20 public WETH = ERC20(0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9);

    address public balancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
}
