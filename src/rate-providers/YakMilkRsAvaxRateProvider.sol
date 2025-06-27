// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

interface YakMilkAccountantInterface {
    function getRate() external view returns (uint256);
}

interface BenqiSAvaxRateProviderInterface {
    function getRate() external view returns (uint256);
}

contract YakMilkRsAvaxRateProvider {
    BenqiSAvaxRateProviderInterface public immutable benqiProvider;
    YakMilkAccountantInterface public immutable yakMilkProvider;

    constructor(
        address benqiProviderAddress,
        address yakMilkProviderAddress
    ) {
        benqiProvider = BenqiSAvaxRateProviderInterface(benqiProviderAddress);
        yakMilkProvider = YakMilkAccountantInterface(yakMilkProviderAddress);
    }

    function getRate() external view returns (uint256) {
        uint256 avaxPerSAvax = benqiProvider.getRate();
        uint256 sAvaxPerShare = yakMilkProvider.getRate();
        return avaxPerSAvax * sAvaxPerShare / 1e18;
    }
}