// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract YakMilkDecoderAndSanitizer is BaseDecoderAndSanitizer {
    function deposit(address depositAsset, uint256, uint256) external pure virtual returns (bytes memory addressesFound) {
        addressesFound = abi.encodePacked(depositAsset);
    }

    function requestWithdraw(address asset,uint96,uint16,bool) external pure virtual returns (bytes memory addressesFound) {
        addressesFound = abi.encodePacked(asset);
    }
}
