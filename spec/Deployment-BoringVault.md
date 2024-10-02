## Setup and Deployment Instructions

### Initial Setup

#### Choose Your Chain

Each new deployment on a new chain should have its own deployment files.

To do this, you will need to create and adapt certain files:

- `scripts/ArchitectureDeployments/{your_chain}/DeployDeployer.s.sol`: adapted from `scripts/ArchitectureDeployments/Sepolia/DeployDeployer.s.sol`
- `scripts/ArchitectureDeployments/{your_chain}/Deploy{your_deployment_name}.s.sol`: adapted from `scripts/ArchitectureDeployments/Sepolia/DeploySepoliasAVAX.s.sol`
- `test/resources/{Your_chain}Addresses.sol`: adapted from `test/resources/SepoliaAddresses.sol`
- `scripts/MerkleRootCreation/{your_chain}/Create{your_deployment_name}SuzakuMerkleRoot.s.sol`: adapted from `scripts/MerkleRootCreation/Sepolia/CreateSepoliaSuzakuMerkleRoot.s.sol`
- `scripts/ArchitectureDeployments/{your_chain}/Deploy{your_deployment_name}AtomicQueue.s.sol`: adapted from `scripts/ArchitectureDeployments/Sepolia/DeploySepoliaAtomicQueue.s.sol`

You will also need to modify the following file if you are making use of the Merkle Root creation:

- `test/resources/ChainValues.sol`: add the addresses of your deployment here that will be used for the Merkle Root to target contracts and functions.

**Note:** The rest of the deployment explanation will use the Sepolia files as an example deployment.

#### Environment Variables

Verify and update the environment variables that you will be using; in our case, it will be `.env.sepolia`.

Then you can run the following command:

```bash
set -a; source .env.sepolia
```

Confirm addresses in Sepolia: `test/resources/SepoliaAddresses.sol`

### Build and Deployment

- Build the project:

  ```bash
  forge build
  ```

Deploy the Deployer script. This will set up a deployer that will be in charge of launching all other contracts:

```bash
forge script scripts/ArchitectureDeployments/Sepolia/DeployDeployer.s.sol:DeployDeployerScript --slow --with-gas-price 30000000000 --broadcast --etherscan-api-key $ETHERSCAN_API_KEY
```

Update the Deployer address in `SepoliaAddresses.sol` and rebuild.

### Set Up Your Variables

We will be defining which tokens the deployment will use. In our example, this means modifying `DeploySepoliaBTCb.s.sol` and `SepoliaAddresses.sol`. Particularly in `DeploySepoliaBTCb.s.sol`, you will add or modify:

- **Base Token:** Add the base token (for instance, BTC.b). This will define the asset class.
- **Public Access:** Define if public deposits or withdrawals are available.
- **Additional Assets:** Specify what *additional* assets can be added or withdrawn. You will also need to define additional categories such as the completion window and withdrawal fee.
- **Deployment Stage:** Define the stage of the deployment. This script can be launched part by part by defining the booleans in `configureDeployment`. For more information on what this activates, you will need to check the `scripts/ArchitectureDeployments/DeployArcticArchitecture.sol` contract.

After these modifications, you can deploy the vault:

```bash
forge script scripts/ArchitectureDeployments/Sepolia/DeploySepoliaBTCb.s.sol:DeploySepoliaBTCb --with-gas-price 30000000000 --broadcast --etherscan-api-key $ETHERSCAN_API_KEY --verify -vvvvv
```

## Base Architecture Post-Deployment Flow

To interact with the contracts, you can find the complete deployment in `deployments/SepoliaDeployment.json`. Here is a basic flow of what can be done with this base deployment. For additional steps, you can check the tests.

- **Mint Tokens:** Mint underlying `ERC20` tokens to an address and approve the BoringVault contract to manage the underlying `ERC20`.
- **Deposit Tokens:** Deposit the `ERC20` through the `Teller` contract. This contract will also be used for withdrawals if the `AtomicQueue` is deployed later. Otherwise, we will use `DelayedWithdraw` in the following steps.
- **Verify Withdrawal Assets:** Check if the deposited `ERC20` exists as a withdrawal asset in the `DelayedWithdraw` contract. If not, refer to the previous section to configure this.
- **Configure `pullFundsFromVault`:** Verify if `pullFundsFromVault` is set to `true`. If not, it will need to be updated using the `setPullFundsFromVault` function.
  - To do this, you will need to add a role to your address to enable modification:

    ```
    #   Name    Type     Data
    0   role    uint8    8
    1   code    address  <DelayedWithdraw>
    2   sig     bytes4   0xb013c6c5   # Method ID of pullFundsFromVault
    3   enabled bool     true
    ```

  - Use `setPullFundsFromVault` to change `pullFundsFromVault` to `true`.
- **Approve Share Token:** Approve the BoringVault share token for the `DelayedWithdraw` contract to manage.
- **Initiate Withdrawal:** Withdraw through the `DelayedWithdraw` using `requestWithdrawal`.
- **Complete Withdrawal:** Wait for the specified period to complete the withdrawal.

## Managers and Merkle Tree Deployment

This setup allows the BoringVault to redistribute assets. These actions will be performed by a Strategist, which can be either an Externally Owned Account (EOA) or a contract called `uManager`.

To learn more about creating interactions with other contracts and how to interact with the Merkle Tree and Managers, please refer to [`specs/uManager.md`](specs/uManager.md).

To deploy the `uManager` that allows interaction with the default collateral of BTC.b, follow these steps:

### Set Up Collateral uManager

1. **Update Chain Values:** Update `test/resources/ChainValues.sol` with the contract addresses of the underlying tokens, collateral, and core vault tokens.

2. **Modify Deployment Script:** Update `DeploySepoliaSuzakuUManager.s.sol` if required.

3. **Deploy `SuzakuUManager`:**

   ```bash
   forge script scripts/DeploySepoliaSuzakuUManager.s.sol:DeploySepoliaSuzakuUManagerScript --slow --with-gas-price 100000000000 --broadcast --etherscan-api-key $ETHERSCAN_API_KEY --verify
   ```

   **Note:** Information about the root and leaves can be found in `leafs/sepoliaSuzakuSniperLeaves.json`.

4. **Set Management Root:** Add the root using the function `setManageRoot(strategist, newRoot)` in the `ManagerWithMerkleVerification` contract. The `strategist` will be the address of the `uManager` that was previously deployed, and `newRoot` can be found in `leafs/sepoliaSuzakuSniperLeaves.json`.

5. **Assign Roles and Permissions:** Grant the correct roles and permissions to the `uManager` address to interact with the `RolesAuthority` contract.

### Set Up Vault uManager

**Note:** This requires the Core Vault to be deployed.

1. **Update Chain Values:** Update `test/resources/ChainValues.sol` with the contract addresses of the underlying tokens, collateral, and core vault tokens.

2. **Modify Deployment Script:** Update `DeploySepoliaVaultUManager.s.sol` if required.

3. **Deploy `SuzakuVaultUManager`:**

   ```bash
   forge script scripts/DeploySepoliaVaultUManager.s.sol:DeploySepoliaVaultUManagerScript --slow --with-gas-price 10000000000 --broadcast --etherscan-api-key $ETHERSCAN_API_KEY --verify
   ```

   **Note:** Information about the root and leaves can be found in `leafs/sepoliaSuzakuVaultSniperLeaves.json`.

4. **Set Management Root:** Add the root using the function `setManageRoot(strategist, newRoot)` in the `ManagerWithMerkleVerification` contract. The `strategist` will be the address of the `uManager` that was previously deployed, and `newRoot` can be found in `leafs/sepoliaSuzakuVaultSniperLeaves.json`.

5. **Assign Roles and Permissions:** Grant the correct roles and permissions to the `uManager` address to interact with the `RolesAuthority` contract.

