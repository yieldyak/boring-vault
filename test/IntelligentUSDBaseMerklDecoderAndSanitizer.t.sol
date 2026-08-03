// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Test} from "forge-std/Test.sol";
import {
    IntelligentUSDBaseDecoderAndSanitizer
} from "src/base/DecodersAndSanitizers/IntelligentUSDBaseDecoderAndSanitizer.sol";
import {MerklDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/Protocols/MerklDecoderAndSanitizer.sol";

interface IMerklDecoder {
    function claim(
        address[] calldata users,
        address[] calldata tokens,
        uint256[] calldata amounts,
        bytes32[][] calldata proofs
    ) external pure returns (bytes memory);
}

contract IntelligentUSDBaseMerklDecoderAndSanitizerTest is Test {
    address internal constant YIUSD = 0xB5803023B8fa8BFe7d64E373297dFaA24e3B5962;
    address internal constant USDC = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
    address internal constant POSITION_MANAGER = address(0xB1);

    IMerklDecoder internal decoder;

    function setUp() external {
        decoder = IMerklDecoder(address(new IntelligentUSDBaseDecoderAndSanitizer(YIUSD, POSITION_MANAGER)));
    }

    function testClaimSanitizesUserAndToken() external {
        address[] memory users = new address[](1);
        users[0] = YIUSD;

        address[] memory tokens = new address[](1);
        tokens[0] = USDC;

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 1e6;

        bytes32[][] memory proofs = new bytes32[][](1);
        proofs[0] = new bytes32[](0);

        assertEq(decoder.claim(users, tokens, amounts, proofs), abi.encodePacked(YIUSD, USDC));
    }

    function testClaimRejectsMismatchedArrayLengths() external {
        address[] memory users = new address[](1);
        users[0] = YIUSD;

        address[] memory tokens = new address[](0);

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 1e6;

        bytes32[][] memory proofs = new bytes32[][](1);
        proofs[0] = new bytes32[](0);

        vm.expectRevert(MerklDecoderAndSanitizer.MerklDecoderAndSanitizer__InputLengthMismatch.selector);
        decoder.claim(users, tokens, amounts, proofs);
    }
}
