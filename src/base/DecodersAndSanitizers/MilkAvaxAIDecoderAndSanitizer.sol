// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";
import {NativeWrapperDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/NativeWrapperDecoderAndSanitizer.sol";
import {AaveV3DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/AaveV3DecoderAndSanitizer.sol";
import {YakMilkDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/YakMilkDecoderAndSanitizer.sol";
import {YakStrategyDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/YakStrategyDecoderAndSanitizer.sol";
import {YakSimpleSwapDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/YakSimpleSwapDecoderAndSanitizer.sol";

contract MilkAvaxAIDecoderAndSanitizer is
    BaseDecoderAndSanitizer,
    NativeWrapperDecoderAndSanitizer,
    AaveV3DecoderAndSanitizer,
    YakMilkDecoderAndSanitizer,
    YakStrategyDecoderAndSanitizer,
    YakSimpleSwapDecoderAndSanitizer
{
    constructor(address _boringVault) BaseDecoderAndSanitizer(_boringVault) {}

    // Payable variants for V2Payable
    function deposit()
        external
        pure
        override(NativeWrapperDecoderAndSanitizer, YakStrategyDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize - payable variant
        return addressesFound;
    }

    function withdraw(uint256)
        external
        pure
        override(NativeWrapperDecoderAndSanitizer, YakStrategyDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
    }
}
