// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract AaveV4DecoderAndSanitizer is BaseDecoderAndSanitizer {
    //============================== ERRORS ===============================

    error AaveV4DecoderAndSanitizer__ReserveIdTooLarge();
    error AaveV4DecoderAndSanitizer__CollateralDisableNotAllowed();

    //============================== AAVE V4 ===============================

    function supply(uint256 reserveId, uint256, address onBehalfOf)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = _decodeReserveAndAccount(reserveId, onBehalfOf);
    }

    function borrow(uint256 reserveId, uint256, address onBehalfOf)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = _decodeReserveAndAccount(reserveId, onBehalfOf);
    }

    function repay(uint256 reserveId, uint256, address onBehalfOf)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = _decodeReserveAndAccount(reserveId, onBehalfOf);
    }

    function withdraw(uint256 reserveId, uint256, address onBehalfOf)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = _decodeReserveAndAccount(reserveId, onBehalfOf);
    }

    function setUsingAsCollateral(uint256 reserveId, bool useAsCollateral, address onBehalfOf)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        if (!useAsCollateral) revert AaveV4DecoderAndSanitizer__CollateralDisableNotAllowed();
        addressesFound = _decodeReserveAndAccount(reserveId, onBehalfOf);
    }

    function _decodeReserveAndAccount(uint256 reserveId, address onBehalfOf)
        internal
        pure
        returns (bytes memory addressesFound)
    {
        if (reserveId >= type(uint160).max) revert AaveV4DecoderAndSanitizer__ReserveIdTooLarge();

        // The manager includes the target Spoke in each Merkle leaf. Encoding reserveId + 1
        // as an address-shaped sentinel therefore constrains the exact local reserve without
        // coupling this reusable decoder to one Spoke. Adding one keeps reserve ID zero nonzero.
        addressesFound = abi.encodePacked(address(uint160(reserveId + 1)), onBehalfOf);
    }
}
