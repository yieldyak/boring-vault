// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

interface SAvaxInterface {
    function getPooledAvaxByShares(uint256 shareAmount)
        external
        view
        returns (uint256 avaxAmount);
}

contract BenqiSAvaxRateProvider {
    SAvaxInterface public immutable SAVAX;

    constructor(address sAvaxAddress) {
        SAVAX = SAvaxInterface(sAvaxAddress);
    }

    function getRate() external view returns (uint256) {
        return SAVAX.getPooledAvaxByShares(1e18);
    }
}