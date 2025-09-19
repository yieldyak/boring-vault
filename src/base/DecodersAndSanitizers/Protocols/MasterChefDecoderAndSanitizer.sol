// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract MasterChefDecoderAndSanitizer is BaseDecoderAndSanitizer {
    function deposit(uint256 /*pid*/, uint256 /*amount*/) external pure virtual returns (bytes memory addressesFound) {
        // No addresses to sanitize
        return addressesFound;
    }

    function withdraw(uint256 /*pid*/, uint256 /*amount*/) external pure virtual returns (bytes memory addressesFound) {
        // No addresses to sanitize
        return addressesFound;
    }
}
