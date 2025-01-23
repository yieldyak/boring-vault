// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract YakStrategyDecoderAndSanitizer is BaseDecoderAndSanitizer {
    // Basic deposit/withdraw functions for V2 and V3
    function deposit(uint256) external pure virtual returns (bytes memory addressesFound) {
        // No addresses to sanitize
        return addressesFound;
    }

    function depositFor(address receiver, uint256) external pure virtual returns (bytes memory addressesFound) {
        addressesFound = abi.encodePacked(receiver);
    }

    function withdraw(uint256) external pure virtual returns (bytes memory addressesFound) {
        // No addresses to sanitize
        return addressesFound;
    }

    // Payable variants for V2Payable
    function deposit() external pure virtual returns (bytes memory addressesFound) {
        // No addresses to sanitize - payable variant
        return addressesFound;
    }

    function depositFor(address receiver) external pure virtual returns (bytes memory addressesFound) {
        addressesFound = abi.encodePacked(receiver);
    }
}
