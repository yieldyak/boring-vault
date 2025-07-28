// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer, DecoderCustomTypes} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract YakSwapSingleHopDecoderAndSanitizer is BaseDecoderAndSanitizer {
    //============================== ERRORS ===============================

    error YakSwapSingleHopDecoderAndSanitizer__PathMustBeSingleHop();

    //============================== YAKSWAP ===============================

    function swapNoSplit(DecoderCustomTypes.YakSwapTrade calldata _trade, address _to, uint256)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        if (_trade.path.length != 2) {
            revert YakSwapSingleHopDecoderAndSanitizer__PathMustBeSingleHop();
        }

        addressesFound = abi.encodePacked(_trade.path[0], _trade.path[1], address(0), _to);
    }
}
