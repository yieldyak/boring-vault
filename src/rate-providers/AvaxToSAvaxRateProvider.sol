// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

interface SAvaxInterface {
    function getSharesByPooledAvax(uint256 avaxAmount) external view returns (uint256 shareAmount);
}

contract AvaxToSAvaxRateProvider {
    SAvaxInterface public immutable sAVAX;

    constructor(address sAvaxAddress) {
        sAVAX = SAvaxInterface(sAvaxAddress);
    }

    function getRate() external view returns (uint256) {
        return sAVAX.getSharesByPooledAvax(1e18);
    }
}
