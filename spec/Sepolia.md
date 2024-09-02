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
  forge script script/ArchitectureDeployments/Sepolia/DeployDeployer.s.sol:DeployDeployerScript --with-gas-price 30000000000 --slow --broadcast -vvvvvv
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


Merkle:

- Add in test/resources/ChainValues.sol the new deployer and replace all other relevant addresses
- Add in script/MerkleRootCreation/Sepolia/CreateSepoliaSuzakuMerkleRoot.s.sol the relevant - addresess
- Add in script/DeploySepoliaSuzakuUManager.s.sol the relevant addresses
- IMPORTANT: delete/change name of leafs/SuperSuzakuStrategistLeafs.json and sepoliaSuzakuSniperLeafs.json if it's a new deployment
- Sniper should also grant the correct role and permissions for the uManager to be able to use the manageVaultWithMerkleVerification function  
- Add MerkleRoot created by the sniper with strategist: uManager, merkleroot in the sniper


Merkle:

- `test/resources/MerkleTreeHelper.sol`: 
    - This contract automates and manages token approvals, swaps, and bridging operations across multiple blockchain protocols and decentralized exchanges.
    - tokenToSpenderToApprovalInTree: Track token-spender approvals.
    - sourceChain: Identify operational blockchain.
- `script/MerkleRootCreation/Mainnet/CreateSuperSymbioticLRTMerkleRoot.s.sol`
    - Sets up the necessary addresses for generating Merkle roots.
    - Defines arrays of assets, tokens, and configurations for various protocols and scenarios.
    - Generates Merkle roots for the following:
        - Symbiotic: Approve and deposit leaves for different default collaterals.
        - Lido: Leaves for Lido-related operations.
        - EtherFi: Leaves for EtherFi-related operations.
        - Native: Leaves for native asset operations.
        - 1inch: Leaves for general swapping and Uniswap V3 swapping on 1inch.
        - Swell: Leaves for simple staking on Swell.
        - Zircuit: Leaves for Zircuit-related operations.
        - Aave V3: Supply and borrow leaves for various assets.
        - Uniswap V3: Leaves for token pairs on Uniswap V3.
        - FrxEth: Leaves for ERC4626 operations on FrxEth.
        - Fluid fToken: Leaves for Fluid fToken operations.
    - Saves the generated Merkle roots and corresponding leaves to a JSON file.
- `script/DeploySymbioticUManager.s.sol`
    - Sets up the necessary addresses and configurations for deployment.
    - Deploys the SymbioticUManager contract using the Deployer utility.
    - Configures the SymbioticUManager contract with default collateral settings and raw data decoder/sanitizer.
    - Grants specific roles and capabilities to the SymbioticUManager contract through the `RolesAuthority` contract.
    - Transfers ownership of the RolesAuthority and SymbioticUManager contracts to a designated address.


 Merkle Tree-Based Permission System

## 1. Key Components
- **ManagerWithMerkleVerification**: Verifies strategist actions
- **SymbioticUManager**: Enforces additional checks
- **RolesAuthority**: Manages roles and permissions
- **BoringVault**: The managed vault

## 2. Merkle Structure
- **Leaves**: Individual permissions/actions
  - Composition: `keccak256(abi.encodePacked(decodersAndSanitizer, target, valueIsNonZero, selector, argumentAddress_0, ..., argumentAddress_N))`
  - Each leaf represents a specific allowed action
- **Tree**: Hierarchical structure of leaves
- **Root**: Single hash representing the entire tree

## 3. Core Scripts
- `CreateSuperSymbioticLRTMerkleRoot.s.sol`: Generates leaves and Merkle root
- `DeploySymbioticUManager.s.sol`: Deploys and configures contracts

## 4. Deployment Process
1. Create leaves (permissions)
2. Generate Merkle tree and root
3. Deploy ManagerWithMerkleVerification
4. Deploy SymbioticUManager
5. Configure roles and permissions

## 5. Permission Update Process
1. Generate new Merkle tree with updated permissions
   - To add: Include new leaf in tree generation
   - To remove: Omit leaf from tree generation
   - Existing permissions: Include all leaves to be kept
2. Calculate new root from updated tree
3. Call `setManageRoot` with strategist address and new root

## 6. Workflow
1. Strategist submits action with Merkle proof
2. ManagerWithMerkleVerification verifies proof against stored root
3. If valid, action is executed on BoringVault

## 7. Key Functions
- `setManageRoot`: Updates Merkle root for a strategist

This system allows for flexible, updateable permissions without frequent contract redeployments. When updating permissions, a completely new Merkle tree is generated, incorporating all desired permissions (both new and existing). Removing a permission simply means not including it in the new tree generation.




### Merkle Tree and Leaves:

A Merkle tree is a data structure used for efficient verification of large data sets.
Leaves are the individual pieces of data at the bottom of the tree.
In this case, each leaf represents a specific permission or action that a strategist can perform.


### Merkle Root:

The Merkle root is a single hash that represents the entire tree.
It's stored in the ManagerWithMerkleVerification contract and used to verify permissions.


### Deployment Process:
1. Create Leaves: Define all the permissions (leaves) for each strategist.
This is done in the CreateSuperSymbioticLRTMerkleRootScript contract.

2. Generate Merkle Tree: Use the leaves to create a Merkle tree.
This is done using the _generateMerkleTree function.

3. Get Merkle Root: Extract the Merkle root from the generated tree.

4. Deploy ManagerWithMerkleVerification: Deploy this contract with the Merkle root.

5. Deploy SymbioticUManager: This is done in the DeploySymbioticUManagerScript.
It uses the ManagerWithMerkleVerification address.

6. Set up Roles and Permissions: Configure roles in the RolesAuthority contract.


### Used
- ManagerWithMerkleVerification: The main contract that verifies strategist actions.
- RolesAuthority: Manages roles and permissions.
- BoringVault: The vault being managed.

### Modified

- `test/resources/ChainValues.sol` to host _addSepoliaValues and seponia as a chain
- `test/resources/MerkleTreeHelper/MerkleTreeHelper.sol` to add `function _addSuzakuLeafs`, copy of `function _addSymbioticLeafs`


### Created

- SymbioticUManager to SuzakuUManager: A micro-manager that enforces additional checks.
- DeploySymbioticUManager to DeploySepoliaSuzakuUManager: deployment
- mainet/CreateSuperSymbioticLRTMerkleRoot.s to Sepolia/CreateSepoliaSuzakuMerkleRoot
- src/micro-managers/SuzakuUManager.sol

Still unused:

- src/base/DecodersAndSanitizers/Protocols/SuzakuDecoderAndSanitizer.sol
- src/base/DecodersAndSanitizers/SepoliaSuzakuDecoderAndSanitzer.sol -> should make it more minimialist
- src/micro-managers/SuzakuUManager.sol

### Workflow:

- `Strategists` submit actions along with Merkle proofs.
- `ManagerWithMerkleVerification` verifies these proofs against the stored Merkle root.
- If verified, the action is executed on the BoringVault.

### To redeploy for your own purposes:

- Modify the CreateSuperSymbioticLRTMerkleRootScript to define your desired permissions.
- Run this script to generate your Merkle tree and root.
- Use the DeploySymbioticUManagerScript as a template, updating addresses and configurations as needed.
- Deploy your contracts, ensuring you set the correct Merkle root and addresses.
- Set up your roles and permissions in the RolesAuthority contract.

Remember, the leaves define what actions are possible, the Merkle root summarizes these permissions, and the ManagerWithMerkleVerification uses this root to verify and allow actions.


setManageRoot function allows to update the root 
(other important functions here)


#
