// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer, DecoderCustomTypes} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract LFJLBPairDecoderAndSanitizer is BaseDecoderAndSanitizer {

    function approveForAll(
        address spender,
        bool
    ) external pure virtual returns (bytes memory addressesFound) {
        addressesFound = abi.encodePacked(spender);
    }
} 