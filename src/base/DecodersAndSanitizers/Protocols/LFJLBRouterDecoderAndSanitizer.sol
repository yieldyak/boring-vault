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
        address tokenX,
        address tokenY,
        uint16,
        uint256,
        uint256,
        uint256[] memory,
        uint256[] memory,
        address to,
        uint256
    ) external pure virtual returns (bytes memory addressesFound) {
        addressesFound = abi.encodePacked(
            tokenX,
            tokenY,
            to
        );
    }
} 