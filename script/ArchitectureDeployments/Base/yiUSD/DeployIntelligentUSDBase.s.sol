// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {DeployArcticArchitecture, ERC20, Deployer} from "script/ArchitectureDeployments/DeployArcticArchitecture.sol";
import {AddressToBytes32Lib} from "src/helper/AddressToBytes32Lib.sol";
import {BaseAddresses} from "../BaseAddresses.sol";

// Import Decoder and Sanitizer to deploy.
import {
    IntelligentUSDBaseDecoderAndSanitizer
} from "src/base/DecodersAndSanitizers/IntelligentUSDBaseDecoderAndSanitizer.sol";

/**
 * forge script script/ArchitectureDeployments/Base/yiUSD/DeployIntelligentUSDBase.s.sol:DeployIntelligentUSDBase --account deployer --slow --broadcast --verify --retries 20 --delay 15 --verifier etherscan
 * @dev Optionally can change `--with-gas-price` to something more reasonable
 */
contract DeployIntelligentUSDBase is DeployArcticArchitecture, BaseAddresses {
    using AddressToBytes32Lib for address;

    // Deployment parameters
    string public boringVaultName = "Yak Intelligent USD";
    string public boringVaultSymbol = "yiUSD";
    uint8 public boringVaultDecimals = 18;
    address public owner = dev0Address;
    address public deployerContractAddress = 0x95977BbC2Ec4a7E21e4818a5AcE9A43e6a04C291;

    function setUp() external {
        vm.createSelectFork("base");
    }

    function run() external {
        // Configure the deployment.
        configureDeployment.deployContracts = true;
        configureDeployment.setupRoles = true;
        configureDeployment.setupDepositAssets = true;
        configureDeployment.setupWithdrawAssets = true;
        configureDeployment.finishSetup = true;
        configureDeployment.setupTestUser = true;
        configureDeployment.saveDeploymentDetails = true;
        configureDeployment.deployerAddress = deployerContractAddress;
        configureDeployment.WETH = address(WETH);
        configureDeployment.initiatePullFundsFromVault = true;

        // Save deployer.
        deployer = Deployer(configureDeployment.deployerAddress);

        // Define names to determine where contracts are deployed.
        names.rolesAuthority = BaseIntelligentUSDRolesAuthorityName;
        names.lens = BaseIntelligentUSDLensName;
        names.boringVault = BaseIntelligentUSDBoringVaultName;
        names.manager = BaseIntelligentUSDBoringVaultManagerName;
        names.accountant = BaseIntelligentUSDBoringVaultAccountantName;
        names.teller = BaseIntelligentUSDBoringVaultTellerName;
        names.rawDataDecoderAndSanitizer = BaseIntelligentUSDBoringVaultDecoderAndSanitizerName;
        names.delayedWithdrawer = BaseIntelligentUSDBoringVaultDelayedWithdrawer;

        // Define Accountant Parameters.
        accountantParameters.payoutAddress = feeCollectorAddress;
        accountantParameters.base = USDC;
        // Decimals are in terms of `base`.
        accountantParameters.startingExchangeRate = 1e6;
        //  4 decimals
        accountantParameters.managementFee = 0;
        accountantParameters.performanceFee = 0;
        accountantParameters.allowedExchangeRateChangeLower = 0.995e4;
        accountantParameters.allowedExchangeRateChangeUpper = 1.005e4;
        // Minimum time(in seconds) to pass between updated without triggering a pause.
        accountantParameters.minimumUpateDelayInSeconds = 1 days / 4;

        // Define Decoder and Sanitizer deployment details.
        bytes memory creationCode = type(IntelligentUSDBaseDecoderAndSanitizer).creationCode;
        bytes memory constructorArgs =
            abi.encode(deployer.getAddress(names.boringVault), velodromeNonFungiblePositionManager);

        // Configure deposit assets
        depositAssets.push(
            DepositAsset({
                asset: ERC20(USDC),
                isPeggedToBase: true,
                rateProvider: address(0),
                genericRateProviderName: "", // Not needed
                target: address(0), // Not needed
                selector: bytes4(0), // Not needed
                params: [bytes32(0), bytes32(0), bytes32(0), bytes32(0), bytes32(0), bytes32(0), bytes32(0), bytes32(0)]
            })
        );

        // Setup withdraw assets.
        withdrawAssets.push(
            WithdrawAsset({
                asset: USDC, withdrawDelay: 8 hours, completionWindow: 24 hours, withdrawFee: 0, maxLoss: 0.01e4
            })
        );

        bool allowPublicDeposits = true;
        bool allowPublicWithdraws = true;
        uint64 shareLockPeriod = 0;
        address delayedWithdrawFeeAddress = feeCollectorAddress;

        vm.startBroadcast();

        _deploy(
            "BaseIntelligentUSDBoringVaultDeployment.json",
            owner,
            boringVaultName,
            boringVaultSymbol,
            boringVaultDecimals,
            creationCode,
            constructorArgs,
            delayedWithdrawFeeAddress,
            allowPublicDeposits,
            allowPublicWithdraws,
            shareLockPeriod,
            dev0Address
        );

        vm.stopBroadcast();
    }
}
