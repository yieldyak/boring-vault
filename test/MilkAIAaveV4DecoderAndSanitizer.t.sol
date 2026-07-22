// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Test} from "forge-std/Test.sol";
import {AaveV4DecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/AaveV4DecoderAndSanitizer.sol";
import {MilkBTCAIDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/MilkBTCAIDecoderAndSanitizer.sol";
import {MilkUSDAIDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/MilkUSDAIDecoderAndSanitizer.sol";

interface IAaveV4Decoder {
    function supply(uint256 reserveId, uint256 amount, address onBehalfOf) external pure returns (bytes memory);
    function borrow(uint256 reserveId, uint256 amount, address onBehalfOf) external pure returns (bytes memory);
    function repay(uint256 reserveId, uint256 amount, address onBehalfOf) external pure returns (bytes memory);
    function withdraw(uint256 reserveId, uint256 amount, address onBehalfOf) external pure returns (bytes memory);
    function setUsingAsCollateral(uint256 reserveId, bool useAsCollateral, address onBehalfOf)
        external
        pure
        returns (bytes memory);
}

contract MilkAIAaveV4DecoderAndSanitizerTest is Test {
    address internal constant BORING_VAULT = address(0xB0);
    address internal constant POSITION_MANAGER = address(0xB1);
    address internal constant ON_BEHALF_OF = address(0xBEEF);

    IAaveV4Decoder internal aiUsdDecoder;
    IAaveV4Decoder internal aiBtcDecoder;

    function setUp() external {
        aiUsdDecoder = IAaveV4Decoder(address(new MilkUSDAIDecoderAndSanitizer(BORING_VAULT, POSITION_MANAGER)));
        aiBtcDecoder = IAaveV4Decoder(address(new MilkBTCAIDecoderAndSanitizer(BORING_VAULT, POSITION_MANAGER)));
    }

    function testAiUsdDecoderSupportsAaveV4() external {
        _assertAaveV4Routes(aiUsdDecoder);
    }

    function testAiBtcDecoderSupportsAaveV4() external {
        _assertAaveV4Routes(aiBtcDecoder);
    }

    function testAiUsdDecoderRejectsDisablingAaveV4Collateral() external {
        vm.expectRevert(AaveV4DecoderAndSanitizer.AaveV4DecoderAndSanitizer__CollateralDisableNotAllowed.selector);
        aiUsdDecoder.setUsingAsCollateral(2, false, ON_BEHALF_OF);
    }

    function testAiBtcDecoderRejectsDisablingAaveV4Collateral() external {
        vm.expectRevert(AaveV4DecoderAndSanitizer.AaveV4DecoderAndSanitizer__CollateralDisableNotAllowed.selector);
        aiBtcDecoder.setUsingAsCollateral(1, false, ON_BEHALF_OF);
    }

    function _assertAaveV4Routes(IAaveV4Decoder decoder) internal {
        bytes memory expected = abi.encodePacked(address(3), ON_BEHALF_OF);

        assertEq(decoder.supply(2, 1e6, ON_BEHALF_OF), expected);
        assertEq(decoder.borrow(2, 1e6, ON_BEHALF_OF), expected);
        assertEq(decoder.repay(2, 1e6, ON_BEHALF_OF), expected);
        assertEq(decoder.withdraw(2, 1e6, ON_BEHALF_OF), expected);
        assertEq(decoder.setUsingAsCollateral(2, true, ON_BEHALF_OF), expected);
    }
}
