// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer, DecoderCustomTypes} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";
import {AaveV3DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/AaveV3DecoderAndSanitizer.sol";
import {BenqiDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/BenqiDecoderAndSanitizer.sol";
import {BlackholeDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/BlackholeDecoderAndSanitizer.sol";
import {ERC4626DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/ERC4626DecoderAndSanitizer.sol";
import {LFJLBRouterDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/LFJLBRouterDecoderAndSanitizer.sol";
import {LFJLBHooksSimpleRewarderDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/LFJLBHooksSimpleRewarderDecoderAndSanitizer.sol";
import {LFJLBPairDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/LFJLBPairDecoderAndSanitizer.sol";
import {MasterChefDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/MasterChefDecoderAndSanitizer.sol";
import {MerklDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/MerklDecoderAndSanitizer.sol";
import {NativeWrapperDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/NativeWrapperDecoderAndSanitizer.sol";
import {SiloIncentivesControllerDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/SiloIncentivesControllerDecoderAndSanitizer.sol";
import {YakMilkDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/YakMilkDecoderAndSanitizer.sol";
import {YakStrategyDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/YakStrategyDecoderAndSanitizer.sol";
import {YakSimpleSwapDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/YakSimpleSwapDecoderAndSanitizer.sol";

contract MilkBTCAIDecoderAndSanitizer is
    BaseDecoderAndSanitizer,
    AaveV3DecoderAndSanitizer,
    BenqiDecoderAndSanitizer,
    BlackholeDecoderAndSanitizer,
    ERC4626DecoderAndSanitizer,
    LFJLBRouterDecoderAndSanitizer,
    LFJLBHooksSimpleRewarderDecoderAndSanitizer,
    LFJLBPairDecoderAndSanitizer,
    MasterChefDecoderAndSanitizer,
    MerklDecoderAndSanitizer,
    NativeWrapperDecoderAndSanitizer,
    SiloIncentivesControllerDecoderAndSanitizer,
    YakMilkDecoderAndSanitizer,
    YakStrategyDecoderAndSanitizer,
    YakSimpleSwapDecoderAndSanitizer
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

    function deposit(uint256) 
        external 
        pure 
        override(BlackholeDecoderAndSanitizer, YakStrategyDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
    }

    function deposit(uint256, address receiver)
        external
        pure
        override(ERC4626DecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(receiver);
    }

    function mint(uint256)
        external
        pure
        override(BenqiDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
    }

    function redeemUnderlying(uint256)
        external
        pure
        override(BenqiDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
    }

    function withdraw(uint256)
        external
        pure
        override(BlackholeDecoderAndSanitizer, NativeWrapperDecoderAndSanitizer, YakStrategyDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        // No addresses to sanitize
        return addressesFound;
    }

    function withdraw(uint256, address receiver, address owner)
        external
        pure
        override(ERC4626DecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(receiver, owner);
    }
}
