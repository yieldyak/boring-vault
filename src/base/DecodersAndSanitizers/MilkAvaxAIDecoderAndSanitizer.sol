// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer, DecoderCustomTypes} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";
import {AaveV3DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/AaveV3DecoderAndSanitizer.sol";
import {AaveV4DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/AaveV4DecoderAndSanitizer.sol";
import {AesyxBorrowerOperations} from "src/base/DecodersAndSanitizers/Protocols/aesyx/AesyxBorrowerOperations.sol";
import {AesyxWrapper} from "src/base/DecodersAndSanitizers/Protocols/aesyx/AesyxWrapper.sol";
import {
    BenqiLendingDecoderAndSanitizer
} from "src/base/DecodersAndSanitizers/Protocols/benqi/BenqiLendingDecoderAndSanitizer.sol";
import {BlackholeDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/BlackholeDecoderAndSanitizer.sol";
import {
    DeltaPrimeDecoderAndSanitizer
} from "src/base/DecodersAndSanitizers/Protocols/DeltaPrimeDecoderAndSanitizer.sol";
import {ERC4626DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/ERC4626DecoderAndSanitizer.sol";
import {
    LFJLBRouterDecoderAndSanitizer
} from "src/base/DecodersAndSanitizers/Protocols/LFJLBRouterDecoderAndSanitizer.sol";
import {
    LFJLBHooksSimpleRewarderDecoderAndSanitizer
} from "src/base/DecodersAndSanitizers/Protocols/LFJLBHooksSimpleRewarderDecoderAndSanitizer.sol";
import {LFJLBPairDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/LFJLBPairDecoderAndSanitizer.sol";
import {
    MasterChefDecoderAndSanitizer
} from "src/base/DecodersAndSanitizers/Protocols/MasterChefDecoderAndSanitizer.sol";
import {MerklDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/MerklDecoderAndSanitizer.sol";
import {
    NativeWrapperDecoderAndSanitizer
} from "src/base/DecodersAndSanitizers/Protocols/NativeWrapperDecoderAndSanitizer.sol";
import {SiloIncentivesController} from "src/base/DecodersAndSanitizers/Protocols/silo/SiloIncentivesController.sol";
import {
    StableJackDecoderAndSanitizer
} from "src/base/DecodersAndSanitizers/Protocols/StableJackDecoderAndSanitizer.sol";
import {YakMilkDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/YakMilkDecoderAndSanitizer.sol";
import {
    YakStrategyDecoderAndSanitizer
} from "src/base/DecodersAndSanitizers/Protocols/YakStrategyDecoderAndSanitizer.sol";
import {
    YakSimpleSwapDecoderAndSanitizer
} from "src/base/DecodersAndSanitizers/Protocols/YakSimpleSwapDecoderAndSanitizer.sol";

contract MilkAvaxAIDecoderAndSanitizer is
    BaseDecoderAndSanitizer,
    AaveV3DecoderAndSanitizer,
    AesyxBorrowerOperations,
    AesyxWrapper,
    BenqiLendingDecoderAndSanitizer,
    BlackholeDecoderAndSanitizer,
    DeltaPrimeDecoderAndSanitizer,
    ERC4626DecoderAndSanitizer,
    LFJLBRouterDecoderAndSanitizer,
    LFJLBHooksSimpleRewarderDecoderAndSanitizer,
    LFJLBPairDecoderAndSanitizer,
    MasterChefDecoderAndSanitizer,
    MerklDecoderAndSanitizer,
    NativeWrapperDecoderAndSanitizer,
    SiloIncentivesController,
    StableJackDecoderAndSanitizer,
    YakMilkDecoderAndSanitizer,
    YakStrategyDecoderAndSanitizer,
    YakSimpleSwapDecoderAndSanitizer,
    AaveV4DecoderAndSanitizer
{
    constructor(address _boringVault, address _blackholeNonFungiblePositionManager)
        BaseDecoderAndSanitizer(_boringVault)
        BlackholeDecoderAndSanitizer(_blackholeNonFungiblePositionManager)
    {}

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
        override(
            AesyxWrapper,
            BlackholeDecoderAndSanitizer,
            NativeWrapperDecoderAndSanitizer,
            YakStrategyDecoderAndSanitizer
        )
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
    ) external pure override(StableJackDecoderAndSanitizer) returns (bytes memory addressesFound) {
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
    ) external pure override(StableJackDecoderAndSanitizer) returns (bytes memory addressesFound) {
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
        override(YakStrategyDecoderAndSanitizer, DeltaPrimeDecoderAndSanitizer, BlackholeDecoderAndSanitizer)
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

    function withdraw(uint256, uint256[] calldata)
        external
        pure
        override(DeltaPrimeDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
    }

    function addLiquidity(DecoderCustomTypes.LiquidityParameters calldata params)
        external
        pure
        override(LFJLBRouterDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(params.tokenX, params.tokenY, params.to, params.refundTo);
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
    ) external pure override(LFJLBRouterDecoderAndSanitizer) returns (bytes memory addressesFound) {
        addressesFound = abi.encodePacked(tokenX, tokenY, to);
    }

    function claim(address user, uint256[] calldata)
        external
        pure
        override(LFJLBHooksSimpleRewarderDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(user);
    }

    function approveForAll(address spender, bool)
        external
        pure
        override(LFJLBPairDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(spender);
    }
}
