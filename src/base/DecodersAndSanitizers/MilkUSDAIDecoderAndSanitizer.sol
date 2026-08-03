// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer, DecoderCustomTypes} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";
import {AaveV3DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/AaveV3DecoderAndSanitizer.sol";
import {AaveV4DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/AaveV4DecoderAndSanitizer.sol";
import {AvantMintingV2} from "src/base/DecodersAndSanitizers/Protocols/avant/AvantMintingV2.sol";
import {AvantReferralRegistry} from "src/base/DecodersAndSanitizers/Protocols/avant/AvantReferralRegistry.sol";
import {BenqiLendingDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/benqi/BenqiLendingDecoderAndSanitizer.sol";
import {BlackholeDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/BlackholeDecoderAndSanitizer.sol";
import {DeltaPrimeDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/DeltaPrimeDecoderAndSanitizer.sol";
import {ERC4626DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/ERC4626DecoderAndSanitizer.sol";
import {EthenaWithdrawDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/EthenaWithdrawDecoderAndSanitizer.sol";
import {LFJLBRouterDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/LFJLBRouterDecoderAndSanitizer.sol";
import {LFJLBHooksSimpleRewarderDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/LFJLBHooksSimpleRewarderDecoderAndSanitizer.sol";
import {LFJLBPairDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/LFJLBPairDecoderAndSanitizer.sol";
import {MasterChefDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/MasterChefDecoderAndSanitizer.sol";
import {MerklDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/MerklDecoderAndSanitizer.sol";
import {NativeWrapperDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/NativeWrapperDecoderAndSanitizer.sol";
import {SparkRewardsDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/SparkRewardsDecoderAndSanitizer.sol";
import {Silo} from "src/base/DecodersAndSanitizers/Protocols/silo/Silo.sol";
import {YakStrategyDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/YakStrategyDecoderAndSanitizer.sol";
import {YakSimpleSwapDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/YakSimpleSwapDecoderAndSanitizer.sol";

contract MilkUSDAIDecoderAndSanitizer is
    BaseDecoderAndSanitizer,
    AaveV3DecoderAndSanitizer,
    AaveV4DecoderAndSanitizer,
    AvantMintingV2,
    AvantReferralRegistry,
    BenqiLendingDecoderAndSanitizer,
    BlackholeDecoderAndSanitizer,
    DeltaPrimeDecoderAndSanitizer,
    ERC4626DecoderAndSanitizer,
    EthenaWithdrawDecoderAndSanitizer,
    LFJLBRouterDecoderAndSanitizer,
    LFJLBHooksSimpleRewarderDecoderAndSanitizer,
    LFJLBPairDecoderAndSanitizer,
    MasterChefDecoderAndSanitizer,
    MerklDecoderAndSanitizer,
    NativeWrapperDecoderAndSanitizer,
    Silo,
    SparkRewardsDecoderAndSanitizer,
    YakStrategyDecoderAndSanitizer,
    YakSimpleSwapDecoderAndSanitizer
{
    constructor(
        address _boringVault,
        address _blackholeNonFungiblePositionManager
    ) 
        BaseDecoderAndSanitizer(_boringVault)
        BlackholeDecoderAndSanitizer(_blackholeNonFungiblePositionManager)
    {}

    function deposit()
        external
        pure
        override(
            NativeWrapperDecoderAndSanitizer,
            YakStrategyDecoderAndSanitizer
        )
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
    }

    function deposit(uint256) 
        external 
        pure 
        override(
            BlackholeDecoderAndSanitizer,
            DeltaPrimeDecoderAndSanitizer,
            YakStrategyDecoderAndSanitizer
        )
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
    }

    function withdraw(uint256)
        external
        pure
        override(
            BlackholeDecoderAndSanitizer,
            NativeWrapperDecoderAndSanitizer,
            YakStrategyDecoderAndSanitizer
        )
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
    }
}
