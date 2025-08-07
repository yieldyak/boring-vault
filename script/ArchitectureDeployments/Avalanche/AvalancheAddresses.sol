// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {ERC20} from "@solmate/tokens/ERC20.sol";

contract AvalancheAddresses {
    // Liquid Ecosystem
    address public dev0Address = 0xDcEDF06Fd33E1D7b6eb4b309f779a0e9D3172e44; // Will be used for deploying contracts and managing them.
    // address public dev0Address = 0x1A267D3f9f5116dF6ae00A4aD698CdcF27b71920;
    address public liquidPayoutAddress = 0x2D580F9CF2fB2D09BC411532988F2aFdA4E7BefF; // Not used much currently
    address public teamMultisig = 0xEA3e895b0696e161C68486Ee2F85e6Cc6ef962d0;

    // DeFi Ecosystem
    ERC20 public BTCb = ERC20(0x152b9d0FdC40C096757F570A51E494bd4b943E50);
    ERC20 public ggAVAX = ERC20(0xA25EaF2906FA1a3a13EdAc9B9657108Af7B703e3);
    ERC20 public sAVAX = ERC20(0x2b2C81e08f1Af8835a78Bb2A90AE924ACE0eA4bE);
    ERC20 public WETH = ERC20(0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7);
    ERC20 public USDC = ERC20(0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E);
    ERC20 public SUZ = ERC20(0x451532F1C9eb7E4Dc2d493dB52b682C0Acf6F5EF);
}
