## Setup and Deployment Instructions

### Initial Setup

#### Choose your chain

Each new deployment, in each chain, should have it's own deployment files.

For that you will to create and adapt certain files:
- `scripts/ArchitectureDeployments/{your_chain}/DeployDeployer.s.sol`: adapted from `script/ArchitectureDeployments/Sepolia/DeployDeployer.s.sol`
- `scripts/ArchitectureDeployment/{your_chain}/Deploy{your_deployment_name}.s.sol`: adapted from `script/ArchitectureDeployments/Sepolia/DeploySepoliasAVAX.s.sol`
- `test/resources/{Your_chain}Addresses.sol`: adapted from `test/resources/SepliaAddresses.sol`
- `script/MerkleRootCreation/{your_chain}/Create{your_deployment_name}SuzakuMerkleRoot.s.sol`: adapted from `script/MerkleRootCreation/Sepolia/CreateSepoliaSuzakuMerkleRoot.s.sol`.
- `script/ArchitectureDeployments/{your_chain}/Deploy{your_deployment_name}AtomicQueue.s.sol`: adapted from `script/ArchitectureDeployments/Sepolia/DeploySepoliaAtomicQueue.s.sol`

You will also need to modify the following files in case of making use of the MerkleRootCreationg:
- `test/resources/ChainValues.sol`: add the addresses of your deployment ehre that will be used for the MerkleRoot to target contracts and functions.

Note: the rest of the deployment explanation will use the Sepolia files as an example deployment.

#### Environment Variables

Verify and update environment variables that you will be using, in our case it will be .env.sepolia. 

Then you can run the following commands:

 ```bash
  set -a; source .env.sepolia
 ```
Confirm addresses in Seplia: `test/resources/SepliaAddresses.sol`

### Build and Deployment

- Build the project:
 ```bash
  forge build
 ```
Deploy the Deployer script. This will setup a deployer which will be in charge of launching all other contracts:

 ```bash
  forge script script/ArchitectureDeployments/Sepolia/DeployDeployer.s.sol:DeployDeployerScript --slow --with-gas-price 30000000000 --broadcast --etherscan-api-key $ETHERSCAN_API_KEY
 ```
Update the Deployer address in `SepliaAddresses.sol` and rebuild.

### Setup your variables;

We will be defining what tokens the deployment will be using, In our example it means modifying  `DeploySepoliaBTCb.s.sol` and `SepliaAddresses.sol`. Particulartly in `DeploySepoliaBTCb.s.sol` you will add/modify:
    - Add base token (for isntance, BTC.b). This will define the asset class. 
    - Define if public deposits or withdrawals are available.
    - Define what *additional* assets can be added or withdrawed, you will also have to define additional categories such as the completion Window and withdraw Fee.
    - Define the stage of the deployment. This script can be launched part-by-part by definiing the booleans in configureDeployment. For more information of what this activates you will have to check on the `script/ArchitectureDeployments/DeployArcticArchitecture.sol` contract.

Adter this modifications, you can deploy the vault:

 ```bash
  forge script script/ArchitectureDeployments/Sepolia/DeploySepoliaBTCb.s.sol:DeploySepoliaBTCb --with-gas-price 30000000000 --broadcast --etherscan-api-key $ETHERSCAN_API_KEY --verify -vvvvv 

 ```

## Base Architecture post-deployment flow:

To interact with the contracts you can find the complete deployment in `deployments/SepoliaDeployment.json`.
Here is a basic flow of what can be done with this base deployment. For additional steps you can check on the tests. 

- Mint underlying `ERC20` to an address and approve for the underlying `ERC20` to be managed by the BoringVault contract.
- Deposit the `ERC20` through Teller contract. This contract will also be used for withdrawal in case of the AtomicQueue being deployed later. Otherwise we will use `DelayedWithdraw` in the following steps.
- Check if the deposited `ERC20` exists as a withdrawal assets in the `DelayedWithdraw` contract. Otherwise check on the previous section to configure this.
- Check if `pullFundsFromVault` is set to true, otherwise it will have to be updated through the function `setPullFundsFromVault`
    - To do this, you will have to add for your address role to be able to modify this:
    ```
    #	Name	Type	Data
    0	role	uint8	8
    1	code	address	<DelayedWithdraw>
    2	sig	bytes4	0xb013c6c5 < this is the methodID of pullFundsFromVault
    3	enabled	bool	true
    ```
    - Use `setPullFundsFromVault` to change `pullFundsFromVault` to `true`.
- Approve BoringVault share token for the `DelayedWithdraw` contract to manage
- Withdraw through the DelayerWithdraw with RequestWIthdrawal
- Wait for period to complete the withdrawal.


## Managers and MerkleTree Deployment:

This is used to allow the BoringVault to redistribute assets. These actions will be done by a Strategist, which is either an EOA or a contract called `uManager`. 

To read more about how to create interactions with other contracts, or more about how to interact with the MerkleTree and Managers, please refer to `specs/uManager.md`

To deploy the `uManager` that allows interaction with the Default Collateral of BTC.B, run the following contract

### Setup Collateral uManager

1. Update `test/resources/ChainValues.sol` with the contract addresses of the underlying tokens, collateral, core vault tokens.

2. Update `DeploySepoliaSuzakuUManager` if required.

3. Deploy suzakuUmanager

```bash
forge script script/DeploySepoliaSuzakuUManager.s.sol:DeploySepliaSuzakuUManagerScript --slow --with-gas-price 100000000000 --broadcast --etherscan-api-key $ETHERSCAN_API_KEY --verify                              
```

Note: find information about this root and leafs in `leafs/sepoliaSuzakuSniperLeafs.json`.

4. Add the Root with the function `setManageRoot(strategist, newRoot)` in the `ManagerWithMerkleVerification` contract. Strategist will be the address of the uManager that was previously deployed, and the newRoot can be found in `leafs/sepoliaSuzakuSniperLeafs.json`.

5. Give correct roles and permissions to `uManager` address to interct with the `RolesAuthority` contract.


### Setup Collateral uManager

Note: this requires the Core Vault to be deployed.

1. Update `test/resources/ChainValues.sol` with the contract addresses of the underlying tokens, collateral, core vault tokens.

2. Update `DeploySepoliaVaultUManager.s.sol` if required.

3. Deploy suzakuUmanager

```bash
forge script script/DeploySepoliaVaultUManager.s.sol:DeploySepoliaVaultUManagerScript --slow  --with-gas-price 10000000000 --broadcast --etherscan-api-key $ETHERSCAN_API_KEY --verify

```

Note: find information about this root and leafs in `leafs/sepoliaSuzakuVaultSniperLeaf.json`.

4. Add the Root with the function `setManageRoot(strategist, newRoot)` in the `ManagerWithMerkleVerification` contract. Strategist will be the address of the uManager that was previously deployed, and the newRoot can be found in `leafs/sepoliaSuzakuVaultSniperLeaf.json`.

5. Give correct roles and permissions to `uManager` address to interct with the `RolesAuthority` contract.
