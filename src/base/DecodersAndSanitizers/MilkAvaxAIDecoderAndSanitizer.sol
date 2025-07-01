// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer, DecoderCustomTypes} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";
import {NativeWrapperDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/NativeWrapperDecoderAndSanitizer.sol";
import {AaveV3DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/AaveV3DecoderAndSanitizer.sol";
import {DeltaPrimeDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/DeltaPrimeDecoderAndSanitizer.sol";
import {StableJackDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/StableJackDecoderAndSanitizer.sol";
import {YakMilkDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/YakMilkDecoderAndSanitizer.sol";
import {YakStrategyDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/YakStrategyDecoderAndSanitizer.sol";
import {YakSimpleSwapDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/YakSimpleSwapDecoderAndSanitizer.sol";

contract MilkAvaxAIDecoderAndSanitizer is
    BaseDecoderAndSanitizer,
    NativeWrapperDecoderAndSanitizer,
    AaveV3DecoderAndSanitizer,
    DeltaPrimeDecoderAndSanitizer,
    StableJackDecoderAndSanitizer,
    YakMilkDecoderAndSanitizer,
    YakStrategyDecoderAndSanitizer,
    YakSimpleSwapDecoderAndSanitizer
{
    constructor(address _boringVault) BaseDecoderAndSanitizer(_boringVault) {}

    function deposit()
        external
        pure
        override(NativeWrapperDecoderAndSanitizer, YakStrategyDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
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

    function deposit(address depositAsset, uint256, uint256)
        external
        pure
        override(YakMilkDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(depositAsset);
    }

    function requestWithdraw(address asset, uint96, uint16, bool)
        external
        pure
        override(YakMilkDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(asset);
    }

    function mintToken(
        DecoderCustomTypes.StableJackGroupKey calldata groupKey,
        DecoderCustomTypes.StableJackMintParams calldata params
    )
        external
        pure
        override(StableJackDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
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
    )
        external
        pure
        override(StableJackDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(
            groupKey.core.aToken,
            groupKey.core.xToken,
            groupKey.core.baseToken,
            groupKey.core.yieldBearingToken,
            groupKey.core.wethToken,
            params.desiredCollateral
        );
    }

    function deposit(uint256) 
        external 
        pure 
        override(YakStrategyDecoderAndSanitizer, DeltaPrimeDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
    }

    function depositNativeToken() 
        external 
        pure 
        override(DeltaPrimeDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
    }

    function createWithdrawalIntent(uint256) 
        external 
        pure 
        override(DeltaPrimeDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
    }

    function withdraw(uint256,uint256[] calldata) 
        external 
        pure 
        override(DeltaPrimeDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
    }
}
