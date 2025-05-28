// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer, DecoderCustomTypes} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract StableJackDecoderAndSanitizer is BaseDecoderAndSanitizer {

    function mintToken(
        DecoderCustomTypes.StableJackGroupKey calldata groupKey,
        DecoderCustomTypes.StableJackMintParams calldata params
    ) external pure virtual returns (bytes memory addressesFound) {
        addressesFound = abi.encodePacked(
            groupKey.core.aToken,
            groupKey.core.xToken,
            groupKey.core.baseToken,
            groupKey.core.yieldBearingToken,
            groupKey.core.wethToken,
            params.paymentToken
        );
    }

    function redeemToken(
        DecoderCustomTypes.StableJackGroupKey calldata groupKey,
        DecoderCustomTypes.StableJackRedeemParams calldata params
    ) external pure virtual returns (bytes memory addressesFound) {
        addressesFound = abi.encodePacked(
            groupKey.core.aToken,
            groupKey.core.xToken,
            groupKey.core.baseToken,
            groupKey.core.yieldBearingToken,
            groupKey.core.wethToken,
            params.desiredCollateral
        );
    }
}
