// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract LFJLBHooksSimpleRewarderDecoderAndSanitizer is BaseDecoderAndSanitizer {

    function claim(
        address user,
        uint256[] calldata
    ) external pure virtual returns (bytes memory addressesFound) {
        addressesFound = abi.encodePacked(user);
    }
} 