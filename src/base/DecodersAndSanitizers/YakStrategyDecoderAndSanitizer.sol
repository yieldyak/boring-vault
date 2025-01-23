// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";
import {NativeWrapperDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/NativeWrapperDecoderAndSanitizer.sol";
import {YakStrategyDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/YakStrategyDecoderAndSanitizer.sol";

contract MilkAIDecoderAndSanitizer is
    BaseDecoderAndSanitizer,
    NativeWrapperDecoderAndSanitizer,
    YakStrategyDecoderAndSanitizer
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
