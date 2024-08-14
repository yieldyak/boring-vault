## Setup and Deployment Instructions

### Initial Setup

- Verify and update environment variables:
 ```bash
  set -a; source .env.sepolia
 ```
- Confirm addresses in Seplia: `test/resources/SepliaAddresses.sol`

### Build and Deployment
- Build the project:
 ```bash
  forge build
 ```
- Deploy the Deployer script:
 ```bash
  forge script script/ArchitectureDeployments/Seplia/DeployDeployer.s.sol:DeployDeployerScript --with-gas-price 30000000000 --slow --broadcast -vvvvvv
 ```
- Update the Deployer address in `SepliaAddresses.sol` and rebuild.

### Tokens

Add tokens you want to use in `DeploySepoliaBTCb.s.sol` and `SepliaAddresses.sol`

### Configure and Deploy Vault
- Modify `DeploySepliaTempVault.s.sol` as needed (additional tokens, public deposits, etc.).
- Deploy the vault:
 ```bash
  forge script script/ArchitectureDeployments/Seplia/DeploySepoliaBTCb.s.sol:DeploySepoliaBTCb --with-gas-price 30000000000 --slow --broadcast -vvvvv
 ```

## Deploy MerkleRoot

***TBD***

## Uses:

- Mint underlying ERC20 to an address.
- Authorize for this address underlying ERC20 to be managed by the BoringVault contract
- Deposit the ERC20 through Teller contract.
- Setup Withdraw Asset throught the DelayerWithdraw contract, defining delay, completition window, fee, max loss and token.
- Withdraw through the DelayerWithdraw

Note: all addresses are located on deployments folder.
