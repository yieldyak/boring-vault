// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract YoDecoderAndSanitizer is BaseDecoderAndSanitizer {
    //============================== YO GATEWAY ===============================

    function deposit(address yoVault, uint256, uint256, address receiver, uint32)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(yoVault, receiver);
    }

    function redeem(address yoVault, uint256, uint256, address receiver, uint32)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(yoVault, receiver);
    }
}
