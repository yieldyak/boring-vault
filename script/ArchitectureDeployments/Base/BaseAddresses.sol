// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {ERC20} from "@solmate/tokens/ERC20.sol";

contract BaseAddresses {
    // Liquid Ecosystem
    // address public dev0Address = 0xDcEDF06Fd33E1D7b6eb4b309f779a0e9D3172e44; // Will be used for deploying contracts and managing them.
    address public dev0Address = 0x1A267D3f9f5116dF6ae00A4aD698CdcF27b71920;
    address public feeCollectorAddress = 0xEA3e895b0696e161C68486Ee2F85e6Cc6ef962d0;
    address public teamMultisig = 0xEA3e895b0696e161C68486Ee2F85e6Cc6ef962d0;

    // DeFi Ecosystem
    ERC20 public USDC = ERC20(0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913);
    ERC20 public WETH = ERC20(0x4200000000000000000000000000000000000006);
    address public velodromeNonFungiblePositionManager = 0x827922686190790b37229fd06084350E74485b72;
}
