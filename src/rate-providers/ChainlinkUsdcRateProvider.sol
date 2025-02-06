// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

interface AggregatorV3Interface {
    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
    function decimals() external view returns (uint8);
}

contract ChainlinkUsdcRateProvider {
    AggregatorV3Interface public immutable ASSET_FEED;
    AggregatorV3Interface public immutable USDC_FEED;
    uint8 public immutable ASSET_FEED_DECIMALS;
    uint8 public immutable USDC_FEED_DECIMALS;
    uint8 public immutable TARGET_DECIMALS;

    error ChainlinkUsdcRateProvider__InvalidPrice();

    constructor(address assetFeed, address usdcFeed, uint8 targetDecimals) {
        ASSET_FEED = AggregatorV3Interface(assetFeed);
        USDC_FEED = AggregatorV3Interface(usdcFeed);
        ASSET_FEED_DECIMALS = ASSET_FEED.decimals();
        USDC_FEED_DECIMALS = USDC_FEED.decimals();
        TARGET_DECIMALS = targetDecimals;
    }

    function getRate() external view returns (uint256) {
        (, int256 assetPrice,,,) = ASSET_FEED.latestRoundData();
        if (assetPrice <= 0) revert ChainlinkUsdcRateProvider__InvalidPrice();

        (, int256 usdcPrice,,,) = USDC_FEED.latestRoundData();
        if (usdcPrice <= 0) revert ChainlinkUsdcRateProvider__InvalidPrice();

        // Normalize prices to common decimals first (18 decimals as standard)
        uint256 normalizedAssetPrice = uint256(assetPrice) * 10 ** (18 - ASSET_FEED_DECIMALS);
        uint256 normalizedUsdcPrice = uint256(usdcPrice) * 10 ** (18 - USDC_FEED_DECIMALS);

        // Calculate rate in 18 decimals
        uint256 rate = (normalizedAssetPrice * 1e18) / normalizedUsdcPrice;

        // Scale to target decimals
        if (18 > TARGET_DECIMALS) {
            rate = rate / 10 ** (18 - TARGET_DECIMALS);
        } else if (18 < TARGET_DECIMALS) {
            rate = rate * 10 ** (TARGET_DECIMALS - 18);
        }

        return rate;
    }
}
