// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {DeployArcticArchitecture, ERC20, Deployer} from "script/ArchitectureDeployments/DeployArcticArchitecture.sol";
import {AddressToBytes32Lib} from "src/helper/AddressToBytes32Lib.sol";
import {AvalancheAddresses} from "../AvalancheAddresses.sol";

// Import Decoder and Sanitizer to deploy.
import {MilkUSDAIDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/MilkUSDAIDecoderAndSanitizer.sol";

/**
 *  source .env && forge script script/ArchitectureDeployments/Avalanche/yyUSDai/DeployUSDMilkAI.s.sol:DeployUSDMilkAI --slow --broadcast --verifier-url 'https://api.routescan.io/v2/network/mainnet/evm/43114/etherscan' --etherscan-api-key "verifyContract" --verify
 *  forge script script/ArchitectureDeployments/Avalanche/yyUSDai/DeployUSDMilkAI.s.sol:DeployUSDMilkAI --account yak-deployer --slow --broadcast --verifier-url 'https://api.routescan.io/v2/network/mainnet/evm/43114/etherscan' --etherscan-api-key "verifyContract" --verify
 * @dev Optionally can change `--with-gas-price` to something more reasonable
 */
contract DeployUSDMilkAI is DeployArcticArchitecture, AvalancheAddresses {
    using AddressToBytes32Lib for address;

    // Deployment parameters
    string public boringVaultName = "Yak Milk Intelligent USD";
    string public boringVaultSymbol = "aiUSD";
    uint8 public boringVaultDecimals = 18;
    address public owner = dev0Address;
    address public deployerContractAddress = 0x07f66f64Bb2CF9B619468f1D46f52d48646f080D;

    function setUp() external {
        vm.createSelectFork("avalanche");
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
        names.rolesAuthority = AvalancheVaultRolesAuthorityName;
        names.lens = ArcticArchitectureLensName;
        names.boringVault = AvalancheVaultName;
        names.manager = AvalancheVaultManagerName;
        names.accountant = AvalancheVaultAccountantName;
        names.teller = AvalancheVaultTellerName;
        names.rawDataDecoderAndSanitizer = AvalancheVaultDecoderAndSanitizerName;
        names.delayedWithdrawer = AvalancheVaultDelayedWithdrawer;

        // Define Accountant Parameters.
        accountantParameters.payoutAddress = liquidPayoutAddress;
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
        bytes memory creationCode = type(MilkUSDAIDecoderAndSanitizer).creationCode;
        bytes memory constructorArgs = abi.encode(deployer.getAddress(names.boringVault));

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
                asset: USDC,
                withdrawDelay: 8 hours,
                completionWindow: 24 hours,
                withdrawFee: 0,
                maxLoss: 0.01e4
            })
        );

        bool allowPublicDeposits = true;
        bool allowPublicWithdraws = true;
        uint64 shareLockPeriod = 0;
        address delayedWithdrawFeeAddress = liquidPayoutAddress;

        vm.startBroadcast();

        _deploy(
            "AvalancheUSDMilkAIDeployment.json",
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
