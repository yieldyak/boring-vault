// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";
import {NativeWrapperDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/NativeWrapperDecoderAndSanitizer.sol";
import {SuzakuDefaultCollateralDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/SuzakuDefaultCollateralDecoderAndSanitizer.sol";
import {SuzakuVaultDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/SuzakuVaultDecoderAndSanitizer.sol";

contract SuzakuDecoderAndSanitizer is
    BaseDecoderAndSanitizer,
    SuzakuDefaultCollateralDecoderAndSanitizer,
    NativeWrapperDecoderAndSanitizer,
    SuzakuVaultDecoderAndSanitizer
{
    constructor(address _boringVault) BaseDecoderAndSanitizer(_boringVault) {}

    // //============================== HANDLE FUNCTION COLLISIONS ===============================

    function withdraw(address recipient, uint256 /*amount*/ )
        external
        pure
        override(SuzakuDefaultCollateralDecoderAndSanitizer, SuzakuVaultDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(recipient);
    }

    function deposit() external pure override(NativeWrapperDecoderAndSanitizer) returns (bytes memory addressesFound) {
        // Nothing to sanitize or return
        return addressesFound;
    }

    function deposit(address recipient, uint256 /*amount*/ )
        external
        pure
        override(SuzakuDefaultCollateralDecoderAndSanitizer, SuzakuVaultDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(recipient);
    }
}
