## Setup and Deployment Instructions

### Initial Setup
- Start Anvil:
 ```bash
  anvil
 ```
- Verify and update environment variables:
 ```bash
  set -a; source .env.anvil
 ```
- Confirm addresses in Anvil, check `test/resources/AnvilAddresses.sol`

### Build and Deployment
- Build the project:
 ```bash
  forge build
 ```
- Deploy the Deployer script:
 ```bash
  forge script script/ArchitectureDeployments/Anvil/DeployDeployer.s.sol:DeployDeployerScript --slow --broadcast -vvvvvv
 ```
- Update the Deployer address in `AnvilAddresses.sol` and rebuild.

### Token Deployment
- Set token parameters:
 ```bash
  TOKEN_NAME="Wrapped Ether"
  TOKEN_SYMBOL="WETH"
  INITIAL_SUPPLY="10000000000000000000"
 ```
- Deploy the token:
 ```bash
  forge script --rpc-url anvil \
    --private-key "$ETHERFI_LIQUID_DEPLOYER" \
    script/ArchitectureDeployments/Anvil/DeployTestERC20.s.sol:DeployTestERC20 --broadcast
 ```
- Update the token address in `AnvilAddresses.sol`.

### Configure and Deploy Vault
- Modify `DeployAnvilTempVault.s.sol` as needed (additional tokens, public deposits, etc.).
- Deploy the vault:
 ```bash
  forge script script/ArchitectureDeployments/Anvil/DeployAnvilTempVault.s.sol:DeployAnvilTempVault --with-gas-price 10000000000 --slow --broadcast -vvvvv
 ```
