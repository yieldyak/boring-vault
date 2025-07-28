// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";
import {NativeWrapperDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/NativeWrapperDecoderAndSanitizer.sol";
import {SuzakuDefaultCollateralDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/SuzakuDefaultCollateralDecoderAndSanitizer.sol";
import {SuzakuVaultDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/SuzakuVaultDecoderAndSanitizer.sol";
import {YakStrategyDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/YakStrategyDecoderAndSanitizer.sol";
import {YakSwapSingleHopDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/YakSwapDecoderAndSanitizer.sol";

contract RsAvaxDecoderAndSanitizer is
    BaseDecoderAndSanitizer,
    NativeWrapperDecoderAndSanitizer,
    YakStrategyDecoderAndSanitizer,
    SuzakuDefaultCollateralDecoderAndSanitizer,
    SuzakuVaultDecoderAndSanitizer,
    YakSwapSingleHopDecoderAndSanitizer
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

    function withdraw(uint256)
        external
        pure
        override(NativeWrapperDecoderAndSanitizer, YakStrategyDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
    }

    function deposit()
        external
        pure
        override(NativeWrapperDecoderAndSanitizer, YakStrategyDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
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
