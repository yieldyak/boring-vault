// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {ERC20} from "@solmate/tokens/ERC20.sol";

contract AvalancheAddresses {
    // Liquid Ecosystem
    address public deployerAddress = 0x67e1195614235005a262650b812E0cED63a0a8B4; //  Used to deploy vault contracts. Replace with Deployer contract address after running Avalanche/DeployDeployer.s.sol script.
    address public dev0Address = 0xDcEDF06Fd33E1D7b6eb4b309f779a0e9D3172e44; // Will be used for deploying contracts and managing them.
    address public liquidPayoutAddress = 0x2D580F9CF2fB2D09BC411532988F2aFdA4E7BefF; // Not used much currently
    address public teamMultisig = 0xEA3e895b0696e161C68486Ee2F85e6Cc6ef962d0;

    // DeFi Ecosystem
    address public ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    ERC20 public BTCb = ERC20(0x152b9d0FdC40C096757F570A51E494bd4b943E50);
    ERC20 public sAVAX = ERC20(0x2b2C81e08f1Af8835a78Bb2A90AE924ACE0eA4bE);
    ERC20 public WETH = ERC20(0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7);
}
