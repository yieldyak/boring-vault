// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer, DecoderCustomTypes} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract LFJLBHooksSimpleRewarderDecoderAndSanitizer is BaseDecoderAndSanitizer {

    function claim(
        DecoderCustomTypes.ClaimParams calldata params
    ) external pure virtual returns (bytes memory addressesFound) {
        addressesFound = abi.encodePacked(params.user);
    }
} 