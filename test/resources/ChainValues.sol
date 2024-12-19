// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {ERC20} from "@solmate/tokens/ERC20.sol";
import {AddressToBytes32Lib} from "src/helper/AddressToBytes32Lib.sol";

contract ChainValues {
    using AddressToBytes32Lib for address;
    using AddressToBytes32Lib for bytes32;

    string public constant mainnet = "mainnet";
    string public constant polygon = "polygon";
    string public constant bsc = "bsc";
    string public constant avalanche = "avalanche";
    string public constant arbitrum = "arbitrum";
    string public constant optimism = "optimism";
    string public constant base = "base";
    string public constant sepolia = "sepolia";

    // Bridging constants.
    uint64 public constant ccipArbitrumChainSelector = 4949039107694359620;
    uint64 public constant ccipMainnetChainSelector = 5009297550715157269;
    uint32 public constant layerZeroBaseEndpointId = 30184;
    uint32 public constant layerZeroMainnetEndpointId = 30101;
    uint32 public constant layerZeroOptimismEndpointId = 30111;
    uint32 public constant layerZeroArbitrumEndpointId = 30110;

    error ChainValues__ZeroAddress(string chainName, string valueName);
    error ChainValues__ZeroBytes32(string chainName, string valueName);
    error ChainValues__ValueAlreadySet(string chainName, string valueName);

    mapping(string => mapping(string => bytes32)) public values;

    function getAddress(string memory chainName, string memory valueName) public view returns (address a) {
        a = values[chainName][valueName].toAddress();
        if (a == address(0)) revert ChainValues__ZeroAddress(chainName, valueName);
    }

    function getERC20(string memory chainName, string memory valueName) public view returns (ERC20 erc20) {
        address a = getAddress(chainName, valueName);
        erc20 = ERC20(a);
    }

    function getBytes32(string memory chainName, string memory valueName) public view returns (bytes32 b) {
        b = values[chainName][valueName];
        if (b == bytes32(0)) revert ChainValues__ZeroBytes32(chainName, valueName);
    }

    function setValue(bool overrideOk, string memory chainName, string memory valueName, bytes32 value) public {
        if (!overrideOk && values[chainName][valueName] != bytes32(0)) {
            revert ChainValues__ValueAlreadySet(chainName, valueName);
        }
        values[chainName][valueName] = value;
    }

    function setAddress(bool overrideOk, string memory chainName, string memory valueName, address value) public {
        setValue(overrideOk, chainName, valueName, value.toBytes32());
    }

    constructor() {
        // Add mainnet values
        _addAvalancheValues();
    }

    // Modify this function to add the values for the new chain
    function _addAvalancheValues() private {
        // Liquid Ecosystem
        values[avalanche]["dev0Address"] = 0xDcEDF06Fd33E1D7b6eb4b309f779a0e9D3172e44.toBytes32();

        // DeFi Ecosystem
        values[avalanche]["ETH"] = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE.toBytes32();

        // ERC20s
        // values[avalanche]["USDC"] = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48.toBytes32();
        values[avalanche]["WETH"] = 0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7.toBytes32();
        values[avalanche]["BTCb"] = 0x152b9d0FdC40C096757F570A51E494bd4b943E50.toBytes32();
        values[avalanche]["sAVAX"] = 0x2b2C81e08f1Af8835a78Bb2A90AE924ACE0eA4bE.toBytes32();
        values[avalanche]["ggAVAX"] = 0xA25EaF2906FA1a3a13EdAc9B9657108Af7B703e3.toBytes32();

        // Suzaku
        values[avalanche]["DC_BTC.b"] = 0x203E9101e09dc87ce391542E705a07522d19dF0d.toBytes32();
        values[avalanche]["DC_sAVAX"] = 0xE3C983013B8c5830D866F550a28fD7Ed4393d5B7.toBytes32();
        values[avalanche]["DC_ggAVAX"] = 0x0CEc099933F0Da490DFF91724b02e2203FAAf9Af.toBytes32();
    }
}
