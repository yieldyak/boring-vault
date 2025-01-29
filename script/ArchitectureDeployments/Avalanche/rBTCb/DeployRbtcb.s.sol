// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import {DeployArcticArchitecture, ERC20, Deployer} from "script/ArchitectureDeployments/DeployArcticArchitecture.sol";
import {AddressToBytes32Lib} from "src/helper/AddressToBytes32Lib.sol";
import {AvalancheAddresses} from "../AvalancheAddresses.sol";

// Import Decoder and Sanitizer to deploy.
import {SuzakuDecoderAndSanitizer} from "src/base/DecodersAndSanitizers/SuzakuDecoderAndSanitizer.sol";

/**
 *  source .env && forge script script/ArchitectureDeployments/Avalanche/rBTCb/DeployRbtcb.s.sol:DeployRbtcb --slow --broadcast --verifier-url 'https://api.routescan.io/v2/network/mainnet/evm/43114/etherscan' --etherscan-api-key "verifyContract" --verify
 * @dev Optionally can change `--with-gas-price` to something more reasonable
 */
contract DeployRbtcb is DeployArcticArchitecture, AvalancheAddresses {
    using AddressToBytes32Lib for address;

    uint256 public privateKey;

    // Deployment parameters
    string public boringVaultName = "Yak Milk Suzaku Restaked BTC.b";
    string public boringVaultSymbol = "rBTC.b";
    uint8 public boringVaultDecimals = 18;
    address public owner = dev0Address;
    address public deployerContractAddress = 0x723D69A0dd91B48D2D678d503fec9C0884dbc480;

    function setUp() external {
        privateKey = vm.envUint("LIQUID_DEPLOYER");
        vm.createSelectFork("avalanche");
    }

    function run() external {
        // Configure the deployment.
        configureDeployment.deployContracts = true;
        configureDeployment.setupRoles = true;
        configureDeployment.setupDepositAssets = true;
        configureDeployment.setupWithdrawAssets = true;
        configureDeployment.finishSetup = true;
        configureDeployment.setupTestUser = false;
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
        accountantParameters.base = BTCb;
        // Decimals are in terms of `base`.
        accountantParameters.startingExchangeRate = 1e18;
        //  4 decimals
        accountantParameters.managementFee = 0;
        accountantParameters.performanceFee = 0;
        accountantParameters.allowedExchangeRateChangeLower = 0.995e4;
        accountantParameters.allowedExchangeRateChangeUpper = 1.005e4;
        // Minimum time(in seconds) to pass between updated without triggering a pause.
        accountantParameters.minimumUpateDelayInSeconds = 1 days / 4;

        // Define Decoder and Sanitizer deployment details.
        bytes memory creationCode = type(SuzakuDecoderAndSanitizer).creationCode;
        bytes memory constructorArgs = abi.encode(deployer.getAddress(names.boringVault));

        // Setup extra deposit assets.
        // none

        // Setup withdraw assets.
        // none

        withdrawAssets.push(
            WithdrawAsset({
                asset: BTCb,
                withdrawDelay: 300 seconds,
                completionWindow: 1500 seconds,
                withdrawFee: 0,
                maxLoss: 0.01e4
            })
        );

        bool allowPublicDeposits = true;
        bool allowPublicWithdraws = true;
        uint64 shareLockPeriod = 0;
        address delayedWithdrawFeeAddress = liquidPayoutAddress;

        vm.startBroadcast(privateKey);

        _deploy(
            "AvalancheRbtcbDeployment.json",
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
