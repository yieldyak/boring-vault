// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Test} from "forge-std/Test.sol";
import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";
import {AaveV4DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/AaveV4DecoderAndSanitizer.sol";

contract TestAaveV4DecoderAndSanitizer is AaveV4DecoderAndSanitizer {
    constructor(address boringVault) BaseDecoderAndSanitizer(boringVault) {}
}

contract AaveV4DecoderAndSanitizerTest is Test {
    TestAaveV4DecoderAndSanitizer internal decoder;

    address internal constant BORING_VAULT = address(0xB0);
    address internal constant ON_BEHALF_OF = address(0xBEEF);

    function setUp() external {
        decoder = new TestAaveV4DecoderAndSanitizer(BORING_VAULT);
    }

    function testSupplyReturnsReserveIdSentinelAndOnBehalfOf() external {
        assertEq(decoder.supply(2, 1e6, ON_BEHALF_OF), abi.encodePacked(address(3), ON_BEHALF_OF));
    }

    function testBorrowReturnsReserveIdSentinelAndOnBehalfOf() external {
        assertEq(decoder.borrow(2, 1e6, ON_BEHALF_OF), abi.encodePacked(address(3), ON_BEHALF_OF));
    }

    function testRepayReturnsReserveIdSentinelAndOnBehalfOf() external {
        assertEq(decoder.repay(2, 1e6, ON_BEHALF_OF), abi.encodePacked(address(3), ON_BEHALF_OF));
    }

    function testWithdrawReturnsReserveIdSentinelAndOnBehalfOf() external {
        assertEq(decoder.withdraw(2, 1e6, ON_BEHALF_OF), abi.encodePacked(address(3), ON_BEHALF_OF));
    }

    function testReserveIdZeroUsesNonZeroSentinel() external {
        assertEq(decoder.supply(0, 1 ether, ON_BEHALF_OF), abi.encodePacked(address(1), ON_BEHALF_OF));
    }

    function testReserveIdsProduceDistinctPackedArguments() external {
        bytes memory reserveZero = decoder.supply(0, 1 ether, ON_BEHALF_OF);
        bytes memory reserveOne = decoder.supply(1, 1 ether, ON_BEHALF_OF);

        assertNotEq(keccak256(reserveZero), keccak256(reserveOne));
    }

    function testReserveIdTooLargeReverts() external {
        vm.expectRevert(AaveV4DecoderAndSanitizer.AaveV4DecoderAndSanitizer__ReserveIdTooLarge.selector);
        decoder.supply(type(uint160).max, 1 ether, ON_BEHALF_OF);
    }
}
