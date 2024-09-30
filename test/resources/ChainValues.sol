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
        _addSepoliaValues();
    }

    // Modify this function to add the values for the new chain
    function _addSepoliaValues() private {
        // Liquid Ecosystem
        values[sepolia]["deployerAddress"] = 0xF4B6D91B7DD8A360ad207Ba3D2109C42e7A6E3C7.toBytes32();
        values[sepolia]["dev0Address"] = 0x0691D2A17B46608a0B5A926a5a511E773f9bA036.toBytes32();
        values[sepolia]["dev1Address"] = 0x0691D2A17B46608a0B5A926a5a511E773f9bA036.toBytes32();
        values[sepolia]["liquidPayoutAddress"] = 0x0691D2A17B46608a0B5A926a5a511E773f9bA036.toBytes32();
        // values[sepolia]["liquidV1PriceRouter"] = 0x693799805B502264f9365440B93C113D86a4fFF5.toBytes32();
        // values[sepolia]["liquidMultisig"] = 0xCEA8039076E35a825854c5C2f85659430b06ec96.toBytes32();

        // DeFi Ecosystem
        values[sepolia]["ETH"] = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE.toBytes32();
        // values[sepolia]["uniV3Router"] = 0xE592427A0AEce92De3Edee1F18E0157C05861564.toBytes32();
        // values[sepolia]["uniV2Router"] = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D.toBytes32();

        // ERC20s
        // values[sepolia]["USDC"] = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48.toBytes32();
        values[sepolia]["WETH"] = 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9.toBytes32();
        values[sepolia]["BTCb"] = 0x5f6887Dc1Cb759c47BD435448f7702209efB6c09.toBytes32();
        values[sepolia]["sAVAX"] = 0x85D6d9E0D5721Eb32Eed28429e89A85F2148713b.toBytes32();

        // Suzaku
        values[sepolia]["DC_BTC.b"] = 0xceAf9Ba87E425CCb91e301A4a06d2F381A22766E.toBytes32();
        values[sepolia]["DC_sAVAX"] = 0x8F4709b4c5074f44abFa1224D84E994bA13d41a5.toBytes32();
    }
}
