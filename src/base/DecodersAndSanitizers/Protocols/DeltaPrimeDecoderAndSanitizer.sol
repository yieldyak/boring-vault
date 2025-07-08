// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract DeltaPrimeDecoderAndSanitizer is BaseDecoderAndSanitizer {
    // Basic deposit
    function deposit(uint256) external pure virtual returns (bytes memory addressesFound) {
        // No addresses to sanitize
        return addressesFound;
    }

    // Payable variant
    function depositNativeToken() external pure virtual returns (bytes memory addressesFound) {
        // No addresses to sanitize
        return addressesFound;
    }

    function createWithdrawalIntent(uint256) external pure virtual returns (bytes memory addressesFound) {
        // No addresses to sanitize
        return addressesFound;
    }

    function withdraw(uint256,uint256[] calldata) external pure virtual returns (bytes memory addressesFound) {
        // No addresses to sanitize
        return addressesFound;
    }
}
