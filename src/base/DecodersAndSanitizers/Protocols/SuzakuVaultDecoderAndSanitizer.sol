// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract VaultDecoderAndSanitizer is BaseDecoderAndSanitizer {
    //============================== VAULT ===============================

    function deposit(address onBehalfOf, uint256 /*amount*/)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(onBehalfOf);
    }

    function withdraw(address claimer, uint256 /*amount*/)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(claimer);
    }

    function claim(address recipient, uint256 /*epoch*/)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(recipient);
    }

    function claimBatch(address recipient, uint256[] calldata /*epochs*/)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(recipient);
    }

    function setDepositorWhitelistStatus(address account, bool /*status*/)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(account);
    }
}
