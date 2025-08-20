// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract SiloIncentivesControllerDecoderAndSanitizer is BaseDecoderAndSanitizer {
    //============================== SILO ===============================

    function setClaimer(address _user, address _claimer) external pure virtual returns (bytes memory addressesFound) {
        addressesFound = abi.encodePacked(_user, _claimer);
    }

    function claimRewards(address _to) external pure virtual returns (bytes memory addressesFound) {
        addressesFound = abi.encodePacked(_to);
    }

    function claimRewards(address _to, string[] calldata /*_programNames*/)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(_to);
    }

    function claimRewardsOnBehalf(address _user, address _to, string[] calldata /*_programNames*/)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(_user, _to);
    }
}
