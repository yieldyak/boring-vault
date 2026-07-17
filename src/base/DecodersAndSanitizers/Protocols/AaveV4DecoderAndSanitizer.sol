// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

interface IAaveV4Spoke {
    struct Reserve {
        address underlying;
        address hub;
        uint16 assetId;
        uint8 decimals;
        uint24 collateralRisk;
        uint8 flags;
        uint32 dynamicConfigKey;
    }

    function getReserve(uint256 reserveId) external view returns (Reserve memory);
}

abstract contract AaveV4DecoderAndSanitizer is BaseDecoderAndSanitizer {
    //============================== IMMUTABLES ===============================

    IAaveV4Spoke internal immutable aaveV4Spoke;

    constructor(address _aaveV4Spoke) {
        aaveV4Spoke = IAaveV4Spoke(_aaveV4Spoke);
    }

    //============================== AAVE V4 ===============================

    function supply(uint256 reserveId, uint256, address onBehalfOf)
        external
        view
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = _decodeReserveAndAccount(reserveId, onBehalfOf);
    }

    function borrow(uint256 reserveId, uint256, address onBehalfOf)
        external
        view
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = _decodeReserveAndAccount(reserveId, onBehalfOf);
    }

    function repay(uint256 reserveId, uint256, address onBehalfOf)
        external
        view
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = _decodeReserveAndAccount(reserveId, onBehalfOf);
    }

    function withdraw(uint256 reserveId, uint256, address onBehalfOf)
        external
        view
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = _decodeReserveAndAccount(reserveId, onBehalfOf);
    }

    function _decodeReserveAndAccount(uint256 reserveId, address onBehalfOf)
        internal
        view
        returns (bytes memory addressesFound)
    {
        IAaveV4Spoke.Reserve memory reserve = aaveV4Spoke.getReserve(reserveId);
        addressesFound = abi.encodePacked(reserve.underlying, onBehalfOf);
    }
}
