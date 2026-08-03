// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Test} from "forge-std/Test.sol";
import {MilkUSDAIDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/MilkUSDAIDecoderAndSanitizer.sol";

interface IYakMilkDecoder {
    function deposit(address depositAsset, uint256 amount, uint256 minimumMint) external pure returns (bytes memory);
    function requestWithdraw(address asset, uint96 shares, uint16 maxLoss, bool allowThirdPartyToComplete)
        external
        pure
        returns (bytes memory);
}

contract MilkUSDAIYakMilkDecoderAndSanitizerTest is Test {
    address internal constant BORING_VAULT = address(0xB0);
    address internal constant POSITION_MANAGER = address(0xB1);
    address internal constant ASSET = address(0xA55E7);

    IYakMilkDecoder internal decoder;

    function setUp() external {
        decoder = IYakMilkDecoder(address(new MilkUSDAIDecoderAndSanitizer(BORING_VAULT, POSITION_MANAGER)));
    }

    function testDepositSanitizesDepositAsset() external {
        assertEq(decoder.deposit(ASSET, 1e6, 1e18), abi.encodePacked(ASSET));
    }

    function testRequestWithdrawSanitizesAsset() external {
        assertEq(decoder.requestWithdraw(ASSET, 1e18, 100, true), abi.encodePacked(ASSET));
    }
}
