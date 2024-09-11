// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";
import {UniswapV3DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/UniswapV3DecoderAndSanitizer.sol";
import {SuzakuDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/SuzakuDecoderAndSanitizer.sol";
import {EtherFiDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/EtherFiDecoderAndSanitizer.sol";
import {NativeWrapperDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/NativeWrapperDecoderAndSanitizer.sol";
import {FluidFTokenDecoderAndSanitizer} from
    "src/base/DecodersAndSanitizers/Protocols/FluidFTokenDecoderAndSanitizer.sol";
import {ERC4626DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/ERC4626DecoderAndSanitizer.sol";
import {VaultDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/SuzakuVaultDecoderAndSanitizer.sol";

contract SepoliaSuzakuDecoderAndSanitzer is
    BaseDecoderAndSanitizer,
    UniswapV3DecoderAndSanitizer,
    SuzakuDecoderAndSanitizer,
    EtherFiDecoderAndSanitizer,
    NativeWrapperDecoderAndSanitizer,
    ERC4626DecoderAndSanitizer,
    VaultDecoderAndSanitizer
{
    constructor(address _boringVault, address _uniswapV3NonfungiblePositionManager)
        BaseDecoderAndSanitizer(_boringVault)
        UniswapV3DecoderAndSanitizer(_uniswapV3NonfungiblePositionManager)
    {}

    // //============================== HANDLE FUNCTION COLLISIONS ===============================

    function withdraw(address recipient, uint256 /*amount*/ )
        external
        pure
        override(SuzakuDecoderAndSanitizer, VaultDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(recipient);
    }

    function deposit()
        external
        pure
        override(EtherFiDecoderAndSanitizer, NativeWrapperDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        // Nothing to sanitize or return
        return addressesFound;
    }

    function deposit(address recipient, uint256 /*amount*/)
        external
        pure
        override(SuzakuDecoderAndSanitizer, VaultDecoderAndSanitizer)
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(recipient);
    }
}
