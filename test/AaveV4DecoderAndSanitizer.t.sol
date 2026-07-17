// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Test} from "forge-std/Test.sol";
import {BaseDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";
import {
    AaveV4DecoderAndSanitizer,
    IAaveV4Spoke
} from "src/base/DecodersAndSanitizers/Protocols/AaveV4DecoderAndSanitizer.sol";

contract MockAaveV4Spoke is IAaveV4Spoke {
    mapping(uint256 => Reserve) internal reserves;

    function setReserve(uint256 reserveId, address underlying) external {
        reserves[reserveId].underlying = underlying;
    }

    function getReserve(uint256 reserveId) external view returns (Reserve memory) {
        return reserves[reserveId];
    }
}

contract RawAaveV4SpokeMock {
    address public constant UNDERLYING = address(0xA3);
    address public constant HUB = address(0xB3);

    fallback() external {
        require(msg.sig == IAaveV4Spoke.getReserve.selector);
        bytes memory response = abi.encode(
            UNDERLYING, HUB, type(uint16).max, type(uint8).max, type(uint24).max, type(uint8).max, type(uint32).max
        );
        assembly {
            return(add(response, 0x20), mload(response))
        }
    }
}

contract TestAaveV4DecoderAndSanitizer is AaveV4DecoderAndSanitizer {
    constructor(address boringVault, address spoke)
        BaseDecoderAndSanitizer(boringVault)
        AaveV4DecoderAndSanitizer(spoke)
    {}
}

contract AaveV4DecoderAndSanitizerTest is Test {
    MockAaveV4Spoke internal spoke;
    TestAaveV4DecoderAndSanitizer internal decoder;

    address internal constant BORING_VAULT = address(0xB0);
    address internal constant WAVAX = address(0xA1);
    address internal constant USDC = address(0xA2);
    address internal constant ON_BEHALF_OF = address(0xBEEF);

    function setUp() external {
        spoke = new MockAaveV4Spoke();
        spoke.setReserve(0, WAVAX);
        spoke.setReserve(2, USDC);
        decoder = new TestAaveV4DecoderAndSanitizer(BORING_VAULT, address(spoke));
    }

    function testSupplyReturnsUnderlyingAndOnBehalfOf() external {
        assertEq(decoder.supply(2, 1e6, ON_BEHALF_OF), abi.encodePacked(USDC, ON_BEHALF_OF));
    }

    function testBorrowReturnsUnderlyingAndOnBehalfOf() external {
        assertEq(decoder.borrow(2, 1e6, ON_BEHALF_OF), abi.encodePacked(USDC, ON_BEHALF_OF));
    }

    function testRepayReturnsUnderlyingAndOnBehalfOf() external {
        assertEq(decoder.repay(2, 1e6, ON_BEHALF_OF), abi.encodePacked(USDC, ON_BEHALF_OF));
    }

    function testWithdrawReturnsUnderlyingAndOnBehalfOf() external {
        assertEq(decoder.withdraw(2, 1e6, ON_BEHALF_OF), abi.encodePacked(USDC, ON_BEHALF_OF));
    }

    function testReserveIdChangesPackedUnderlying() external {
        bytes memory wavaxAddresses = decoder.supply(0, 1 ether, ON_BEHALF_OF);
        bytes memory usdcAddresses = decoder.supply(2, 1e6, ON_BEHALF_OF);

        assertEq(wavaxAddresses, abi.encodePacked(WAVAX, ON_BEHALF_OF));
        assertEq(usdcAddresses, abi.encodePacked(USDC, ON_BEHALF_OF));
        assertNotEq(keccak256(wavaxAddresses), keccak256(usdcAddresses));
    }

    function testDecodesRawAaveV4ReserveAbiWithPopulatedFields() external {
        RawAaveV4SpokeMock rawSpoke = new RawAaveV4SpokeMock();
        TestAaveV4DecoderAndSanitizer rawDecoder = new TestAaveV4DecoderAndSanitizer(BORING_VAULT, address(rawSpoke));

        assertEq(rawDecoder.supply(5, 1e6, ON_BEHALF_OF), abi.encodePacked(rawSpoke.UNDERLYING(), ON_BEHALF_OF));
    }
}
