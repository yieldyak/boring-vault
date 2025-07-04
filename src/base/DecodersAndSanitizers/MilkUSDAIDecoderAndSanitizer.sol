// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer, DecoderCustomTypes} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";
import {AaveV3DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/AaveV3DecoderAndSanitizer.sol";
import {YakStrategyDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/YakStrategyDecoderAndSanitizer.sol";
import {YakSimpleSwapDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/YakSimpleSwapDecoderAndSanitizer.sol";

contract MilkUSDAIDecoderAndSanitizer is
    BaseDecoderAndSanitizer,
    AaveV3DecoderAndSanitizer,
    YakStrategyDecoderAndSanitizer,
    YakSimpleSwapDecoderAndSanitizer
{
    constructor(address _boringVault) BaseDecoderAndSanitizer(_boringVault) {}

    function deposit()
        external
        pure
        override(YakStrategyDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
    }

    function withdraw(uint256)
        external
        pure
        override(YakStrategyDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
    }
}
