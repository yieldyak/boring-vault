// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer, DecoderCustomTypes} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";
import {AaveV3DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/AaveV3DecoderAndSanitizer.sol";
import {ERC4626DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/ERC4626DecoderAndSanitizer.sol";
import {
    NativeWrapperDecoderAndSanitizer
} from "src/base/DecodersAndSanitizers/Protocols/NativeWrapperDecoderAndSanitizer.sol";
import {VelodromeDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/VelodromeDecoderAndSanitizer.sol";
import {
    YakSimpleSwapDecoderAndSanitizer
} from "src/base/DecodersAndSanitizers/Protocols/YakSimpleSwapDecoderAndSanitizer.sol";
import {
    MorphoBlueDecoderAndSanitizer
} from "src/base/DecodersAndSanitizers/Protocols/MorphoBlueDecoderAndSanitizer.sol";
import {MerklDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/MerklDecoderAndSanitizer.sol";
import {YoDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/YoDecoderAndSanitizer.sol";

contract IntelligentUSDBaseDecoderAndSanitizer is
    BaseDecoderAndSanitizer,
    AaveV3DecoderAndSanitizer,
    ERC4626DecoderAndSanitizer,
    NativeWrapperDecoderAndSanitizer,
    VelodromeDecoderAndSanitizer,
    YakSimpleSwapDecoderAndSanitizer,
    MorphoBlueDecoderAndSanitizer,
    MerklDecoderAndSanitizer,
    YoDecoderAndSanitizer
{
    constructor(address _boringVault, address _velodromeNonFungiblePositionManager)
        BaseDecoderAndSanitizer(_boringVault)
        VelodromeDecoderAndSanitizer(_velodromeNonFungiblePositionManager)
    {}

    function withdraw(uint256)
        external
        pure
        override(NativeWrapperDecoderAndSanitizer, VelodromeDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        return addressesFound;
    }
}
