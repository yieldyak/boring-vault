// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {IBlackholeNonFungiblePositionManager} from "src/interfaces/IBlackholeNonFungiblePositionManager.sol";
import {BaseDecoderAndSanitizer, DecoderCustomTypes} from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract BlackholeDecoderAndSanitizer is BaseDecoderAndSanitizer {
    //============================== ERRORS ===============================

    error BlackholeDecoderAndSanitizer__BadTokenId();

    //============================== IMMUTABLES ===============================

    /**
     * @notice The networks nonfungible position manager.
     * @notice Avalanche: 0x3fED017EC0f5517Cdf2E8a9a4156c64d74252146
     * @notice
     */
    IBlackholeNonFungiblePositionManager internal immutable blackholeNonFungiblePositionManager;

    constructor(address _blackholeNonFungiblePositionManager) {
        blackholeNonFungiblePositionManager = IBlackholeNonFungiblePositionManager(_blackholeNonFungiblePositionManager);
    }

    //============================== BLACKHOLE CL ===============================

    function mint(DecoderCustomTypes.BlackholeMintParams calldata params)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        // Return addresses found
        addressesFound = abi.encodePacked(params.token0, params.token1, params.deployer, params.recipient);
    }

    function increaseLiquidity(DecoderCustomTypes.IncreaseLiquidityParams calldata params)
        external
        view
        virtual
        returns (bytes memory addressesFound)
    {
        // Sanitize raw data
        if (blackholeNonFungiblePositionManager.ownerOf(params.tokenId) != boringVault) {
            revert BlackholeDecoderAndSanitizer__BadTokenId();
        }
        // Extract addresses from BlackholeNonFungiblePositionManager.positions(params.tokenId).
        (, address operator, address token0, address token1, address deployer,,,,,,,) =
            blackholeNonFungiblePositionManager.positions(params.tokenId);
        addressesFound = abi.encodePacked(operator, token0, token1, deployer);
    }

    function decreaseLiquidity(DecoderCustomTypes.DecreaseLiquidityParams calldata params)
        external
        view
        virtual
        returns (bytes memory addressesFound)
    {
        // Sanitize raw data
        // NOTE ownerOf check is done in PositionManager contract as well, but it is added here
        // just for completeness.
        if (blackholeNonFungiblePositionManager.ownerOf(params.tokenId) != boringVault) {
            revert BlackholeDecoderAndSanitizer__BadTokenId();
        }

        // No addresses in data
        return addressesFound;
    }

    function collect(DecoderCustomTypes.CollectParams calldata params)
        external
        view
        virtual
        returns (bytes memory addressesFound)
    {
        // Sanitize raw data
        // NOTE ownerOf check is done in PositionManager contract as well, but it is added here
        // just for completeness.
        if (blackholeNonFungiblePositionManager.ownerOf(params.tokenId) != boringVault) {
            revert BlackholeDecoderAndSanitizer__BadTokenId();
        }

        // Return addresses found
        addressesFound = abi.encodePacked(params.recipient);
    }

    function burn(uint256 /*tokenId*/ ) external pure virtual returns (bytes memory addressesFound) {
        // positionManager.burn(tokenId) will verify that the tokenId has no liquidity, and no tokens owed.
        // Nothing to sanitize or return
        return addressesFound;
    }

    //============================== BLACKHOLE V2 ===============================

    function addLiquidity(
        address tokenA,
        address tokenB,
        bool, /*stable*/
        uint256, /*amountADesired*/
        uint256, /*amountBDesired*/
        uint256, /*amountAMin*/
        uint256, /*amountBMin*/
        address to,
        uint256 /*deadline*/
    ) external pure returns (bytes memory addressesFound) {
        // Nothing to sanitize
        // Return addresses found
        addressesFound = abi.encodePacked(tokenA, tokenB, to);
    }

    function removeLiquidity(
        address tokenA,
        address tokenB,
        bool, /*stable*/
        uint256, /*liquidity*/
        uint256, /*amountAMin*/
        uint256, /*amountBMin*/
        address to,
        uint256 /*deadline*/
    ) external pure returns (bytes memory addressesFound) {
        // Nothing to sanitize
        // Return addresses found
        addressesFound = abi.encodePacked(tokenA, tokenB, to);
    }

    //============================== BLACKHOLE V2/V3 GAUGE ===============================

    function deposit(uint256 /*tokenId_or_amount*/ ) external pure virtual returns (bytes memory addressesFound) {
        // Nothing to sanitize or return
        return addressesFound;
    }

    function withdraw(uint256 /*tokenId_or_amount*/ ) external pure virtual returns (bytes memory addressesFound) {
        // Nothing to sanitize or return
        return addressesFound;
    }

    // Only callable on V3 gauge
    function getReward(uint256 /*tokenId*/, bool /*isBonusReward*/ ) external pure virtual returns (bytes memory addressesFound) {
        // Nothing to sanitize or return
        return addressesFound;
    }

    function getReward(address account) external pure virtual returns (bytes memory addressesFound) {
        addressesFound = abi.encodePacked(account);
    }
}
