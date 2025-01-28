// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer, DecoderCustomTypes} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract YakSimpleSwapDecoderAndSanitizer is BaseDecoderAndSanitizer {
    function swap(uint256, uint256, address _tokenIn, address _tokenOut)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(_tokenIn, _tokenOut);
    }
}
