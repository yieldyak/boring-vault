// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer, DecoderCustomTypes} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract LFJLBRouterDecoderAndSanitizer is BaseDecoderAndSanitizer {

    function addLiquidity(
        DecoderCustomTypes.LiquidityParameters calldata params
    ) external pure virtual returns (bytes memory addressesFound) {
        addressesFound = abi.encodePacked(
            params.tokenX,
            params.tokenY,
            params.to,
            params.refundTo
        );
    }

    function removeLiquidity(
        DecoderCustomTypes.RemoveLiquidityParams calldata params
    ) external pure virtual returns (bytes memory addressesFound) {
        addressesFound = abi.encodePacked(
            params.tokenX,
            params.tokenY,
            params.to
        );
    }
} 