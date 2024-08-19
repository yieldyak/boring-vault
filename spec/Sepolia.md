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
- Check if the deposited ERC20 exists withdrawal assets in the DelayerWithdraw contract.  
    - If it doesn't exist, Setup Withdraw Asset throught the DelayerWithdraw contract, defining delay, completition window, fee, max loss and token.
- Check if `pullFundsFromVault` (read function) is set to true, otherwise it will have to be updated to true through the function setPullFundsFromVault
    - To do this, you will have to add for your address role to be able to modify this:
    ```
    #	Name	Type	Data
    0	role	uint8	8
    1	code	address	<DelayedWithdraw>
    2	sig	bytes4	0xb013c6c5 < this is the methodID of pullFundsFromVault
    3	enabled	bool	true
    ```
    - Use `setPullFundsFromVault` to change `pullFundsFromVault` to `true`.
- Approve BoringVault share token for te DelayedWithdraw contract to manage
- Withdraw through the DelayerWithdraw with RequestWIthdrawal
- Wait for period 

Note: all addresses are located on deployments folder.


Request withdraw:
- from DW check authority through RolesAuthority
- Call from DW to usdc boringvault, potentially checking permissions of bv token?
- staticall from  BV to teller
- staticall from DW to accountant

This doesn't work as it's stuck in memepool, during deployment
