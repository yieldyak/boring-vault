# BoringVault Withdrawals:

# Comparison `*AtomicQueue*` vs `*DelayedWithdraw*`

**Introduction**

The BoringVault offers two different mechanisms for users to withdraw their assets:

1. **DelayedWithdraw Mechanism**: Implements a time-delayed withdrawal process with user protections like fees and maximum loss limits.
2. **AtomicQueue/Solver Mechanism**: Allows users to create withdrawal requests that are fulfilled by external solvers who profit from facilitating these withdrawals.

---

### **Similarities**

1. **User-Initiated Requests**: Both mechanisms require users to initiate withdrawal requests specifying certain parameters (e.g., amount, acceptable rates).
2. **Exchange Rate Consideration**: Both consider the exchange rate between the asset and its quote currency to ensure users receive fair value.
3. **Third-Party Participation**:
    - **DelayedWithdraw**: Users can allow third parties to complete withdrawals on their behalf.
    - **AtomicQueue/Solver**: External solvers fulfill user requests and facilitate asset exchanges.

---

### **Differences**

1. **Withdrawal Timing**:
    - **DelayedWithdraw**: Introduces a mandatory delay (`withdrawDelay`) before a withdrawal can be completed. Users must wait for this period to elapse.
    - **AtomicQueue/Solver**: Withdrawals can potentially be executed immediately if a solver chooses to fulfill the user's request.
2. **Fulfillment Mechanism**:
    - **DelayedWithdraw**: The contract directly interacts with the vault to process withdrawals. No profit motive for third parties; their involvement is optional and service-based.
    - **AtomicQueue/Solver**: Solvers are incentivized to fulfill requests by profiting from market opportunities. They facilitate the exchange and bear market risks.
3. **Fees and Costs**:
    - **DelayedWithdraw**: May charge a withdrawal fee (defined in contract) that goes to the protocol or fee address.
    - **AtomicQueue/Solver**: Users do not pay explicit protocol fees but may receive less favorable exchange rates based on their `atomicPrice` and market conditions. Fees are paid by the solver, who discounts them from the excess.
4. **User Protection Mechanisms**:
    - **DelayedWithdraw**:
    - **Max Loss (`maxLoss`)**: Users set a maximum acceptable loss **percentage** relative to the exchange rate at the time of the request. This protects them from significant adverse rate movements during the delay period.
    - **AtomicQueue/Solver**:
        - **Minimum Price (`atomicPrice`)**: Users specify the **minimum fixed price** they are willing to accept for their `offer` assets. This ensures they receive at least this rate when the solver fulfills their request.
5. **Complexity and User Experience**:
    - **DelayedWithdraw**: Simpler and more predictable, with clear timelines and user control over the process.
    - **AtomicQueue/Solver**: More complex due to the involvement of external solvers and dependency on market conditions.
6. **Liquidity Management**:
    - **DelayedWithdraw**: The protocol must manage liquidity to fulfill withdrawal requests.
    - **AtomicQueue/Solver**: Solvers provide the necessary liquidity, reducing the protocol's burden.

---

### **Pros and Cons**

### **DelayedWithdraw Mechanism**

**Pros**:

- **User Control and Predictability**: Users have control over the timing of their withdrawals within the specified windows and can cancel if desired.
- **Simplicity**: The process is straightforward and easier for users to understand and interact with.

**Cons**:

- **Mandatory Delay**: Users must wait for the `withdrawDelay` period before they can access their assets, which may be inconvenient in urgent situations.
- **Protocol Liquidity Requirements**: The protocol must ensure sufficient liquidity is available to fulfill withdrawals, which can be challenging during periods of high demand.

### **AtomicQueue/Solver Mechanism**

**Pros**:

- **Potential for Immediate Execution**: Withdrawals can be executed quickly if solvers are available and willing to fulfill requests.
- **Market Efficiency**: Solvers leverage market opportunities to facilitate withdrawals, potentially offering better rates if market conditions are favorable.
- **Reduced Protocol Burden**: Solvers provide the liquidity, easing the protocol's need to manage liquidity for withdrawals.

**Cons**:

- **Complexity**: The involvement of external solvers and multiple contracts adds complexity to the process.
- **Dependency on Solvers**: Execution of withdrawals relies on solvers' availability and willingness to participate, which may not be guaranteed

---

## AtomicQueue/Solver

## **Overview:**

The confusion arises from the use of the term **'solver'** to refer to both an **external address (EOA)** and the **`AtomicSolverV3` contract** in different contexts. Let's clarify at each step who the 'solver' refers to and how the interaction between the external solver and the `AtomicSolverV3` contract works.

---

## **Key Participants:**

1. **Users**: Individuals who have created atomic requests to exchange their `offer` assets for `want` assets.
2. **AtomicQueue Contract**: Manages user requests and coordinates the solving process.
3. **Solver (External Address / EOA)**: An authorized entity (e.g., a market maker) that initiates the solving process and potentially profits from it.
4. **AtomicSolverV3 Contract**: A contract that implements the logic for executing different types of solves (P2P or REDEEM), acting on behalf of the solver (EOA).

## Process Flow

1. **User Requests**:
    - **Action:** Users call `updateAtomicRequest` or `safeUpdateAtomicRequest` on `AtomicQueue` (0xd45884b592e316eb816199615a95c182f75dea07.
    - **Outcome:** User requests are stored in the `AtomicQueue`, specifying the `offer` and `want` assets, along with other parameters like `deadline` and `atomicPrice`.
    - **Note**: No assets are transferred at this stage; users only need to ensure they have approved the `AtomicQueue` to spend their `offer` assets.
2. **Solve Initiation**:
    - **Action**: An authorized **solver EOA** (0xf8553c8552f906c19286f21711721e206ee4909e), an entity with the necessary permissions, calls `p2pSolve` or `redeemSolve` on the `AtomicSolverV3` contract(0x989468982b08aefa46e37cd0086142a86fa466d7).
    - **Outcome**: The `AtomicSolverV3` contract encodes the necessary data and calls the `solve` function on the `AtomicQueue`.
    - **Clarification**:
        - **Solver EOA**: Initiates the solve by interacting with `AtomicSolverV3`.
        - **`AtomicSolverV3` Contract**: Acts on behalf of the solver EOA in subsequent steps.
3. **Asset Transfer During `Solve`**:
    - **Action:**
        - The `AtomicQueue` transfers `offer` assets directly from users to the solver's address.
        - The `AtomicQueue` then calls `finishSolve` on the `AtomicSolverV3` contract.
    - **Outcome:**
        - The solver now holds the users' `offer` assets.
        - The `AtomicSolverV3` is prepared to process the solve, either in P2P or REDEEM mode.
    - **Clarification**:
        - In this context, **'solver'** within `AtomicQueue.solve` refers to the **`AtomicSolverV3` contract**.
4. **AtomicSolver Processing**:
    - **For P2P Solve**
        - **Action**:
            - The **Solver EOA** transfers the required `want` assets to the `AtomicSolverV3` contract with `want.safeTransferFrom(solver, address(this), wantApprovalAmount);`
            - `AtomicSolverV3` transfers the collected `offer` assets to the solver EOA with `offer.safeTransfer(solver, offerReceived);`
            - The `AtomicSolverV3` approves the `AtomicQueue` to spend these `want` assets.
        - **Outcome**:
            - Users will receive `want` assets in exchange for their `offer` assets.
            - The **solver EOA** retains the `offer` assets received from the users.
            - `AtomicSolverV3` holds the `want` assets, approved for the `AtomicQueue` to transfer to users.
        - **Note**:
            - The solver profits if the value of `offer` assets exceeds the `want` assets provided to users.
    - **For REDEEM Solve**
        - **Action**:
            - The `AtomicSolverV3` redeems the `offer` assets (e.g., shares of a vault) through a `TellerWithMultiAssetSupport` contract `bulkwithdraw` function, sending the redeemed `want` assets to the **solver EOA**.
            - The **solver EOA** transfers a slightly smaller portion of required `want` assets BACK to the `AtomicSolverV3` , keeping any excess `want` assets for themselves.
                
                ```solidity
                Excess = redemptionAmount - wantApprovalAmount
                ```
                
            - The `AtomicSolverV3` approves the `AtomicQueue` to spend these `want` assets.
        - **Outcome**:
            - Users receive `want` assets as per their requests.
            - **Solver EOA** retains any excess `want` assets from the redemption process.
            - `AtomicSolverV3` holds the required `want` assets, approved for the `AtomicQueue` to transfer to users.
        - **Note**:
            - The solver profits from any difference between the redeemed amount and the amount required to fulfill user requests.
5. **Distribution to Users**:
    - **Action**: The `AtomicQueue` distributes the `want` assets to the users who participated in the solve.
    - **Outcome**:
        - Users receive the `want` assets as specified in their requests.
        - Their `offer` assets have been transferred to the solver.

## Key Points

- **Atomic Process**: The entire solve occurs within a single transaction, ensuring atomicity and reducing the risk of partial fills or state changes in between steps.
- **User Asset Control**: Users retain control of their `offer` assets until the solve is executed. Their assets are only transferred if all conditions (e.g., deadlines, amounts) are met.
- **Solver's Role**:
    - Temporarily receives user `offer` assets.
    - Provides `want` assets in return, either from their own holdings (P2P) or by redeeming the `offer` assets (REDEEM).
- **AtomicSolverV3's Role**: Acts as an intermediary that enforces the logic of the solve, ensuring that all conditions are met and facilitating the asset transfers between parties.

## Solver Profits

- **In the P2P Case**:
    - Arbitrage: The solver profits if they can acquire `offer` assets from users at a favorable rate and later sell them for a higher price elsewhere.
- **In the REDEEM Case**:
    - The solver redeems the `offer` assets (e.g., vault shares) for `want` assets.
    - If the redeemed amount exceeds the `want` assets required to fulfill user requests, the solver keeps the excess.
    - There are parameters like `maxAssets` and `minimumAssetsOut` to ensure that users receive a fair amount and to limit how much the solver can profit.

## Fees

- **Transaction Fees**: Paid by the entity initiating each transaction (users and solver EOA).
- **Redemption Fees**: Deducted from the redemption amount received by the solver in a REDEEM solve, effectively paid by the solver (as he takes the difference from the `want` assets.
- **Overall Costs for Solver**: Solvers need to consider both gas fees and redemption fees when calculating their expected profit from executing solves.

## Additional Clarifications

- **User Protections**:
    - **Deadline**: Users can specify a deadline after which their request is invalid, protecting them from unfavorable market conditions.
    - **Atomic Price**: Users set an `atomicPrice`, ensuring they receive a minimum acceptable rate for their `offer` assets.
    - **Approvals and Balances**: The `AtomicQueue` checks that users have sufficient balances and allowances before proceeding.
- **Solver Requirements**:
    - **Authorization**: Only entities with the appropriate permissions (e.g., `requiresAuth` modifier) can initiate solves.
    - **Asset Availability**:
        - For P2P solves, solvers must have enough `want` assets to cover user requests.
        - For REDEEM solves, solvers need to handle the redemption process and transfer the required `want` assets to the `AtomicSolverV3`.
- **Atomicity and Security**:
    - The use of non-reentrant modifiers and checks ensures that the process is secure against reentrancy attacks.
    - The entire process is designed to be atomic, meaning it either completes fully or not at all, preventing partial fills or inconsistent states.


## Deployment AQ

```
 *  source .env && forge script script/DeployAtomicQueue.s.sol:DeployAtomicQueueScript --with-gas-price 70000000 --evm-version london --broadcast --etherscan-api-key $ETHERSCAN_API_KEY --verify
```

# DelayedWithdrawal:

**Key Components**

1. **DelayedWithdraw Contract**: Manages delayed withdrawal requests, enforcing delays, fees, and loss limits.
2. **BoringVault**: The vault holding the assets from which users want to withdraw.
3. **Users**: Individuals requesting to withdraw their shares from the vault.
4. **AccountantWithRateProviders**: Provides exchange rates used to calculate asset amounts during withdrawals.

---

**Process Flow**

### 1. **Withdrawal Request**

- **Action**: Users call `requestWithdraw` on the `DelayedWithdraw` contract, specifying:
    - **Asset**: The ERC20 token they wish to withdraw.
    - **Shares**: The number of shares to withdraw.
    - **Max Loss**: Maximum acceptable loss in exchange rate between request and completion.
    - **Allow Third Party to Complete**: Whether a third party can finalize the withdrawal.
- **Outcome**:
    - The user's withdrawal request is recorded.
    - The user's shares are transferred from their wallet to the `DelayedWithdraw` contract.
    - A **maturity time** is set, calculated as `block.timestamp + withdrawDelay`.
    - The exchange rate at the time of request is recorded.

### 2. **Waiting Period**

- Users must wait for the **withdrawal delay period** (`withdrawDelay`) before they can complete their withdrawal.

### 3. **Withdrawal Completion**

- **Action**: After the maturity time and before the **completion window** expires, users or allowed third parties call `completeWithdraw`.
- **Outcome**:
    - The contract checks:
        - The withdrawal has matured.
        - The request is within the completion window.
        - The exchange rate hasn't deviated beyond the acceptable `maxLoss`.
    - If conditions are met:
        - **Withdraw Fee**: If applicable, a fee is deducted from the shares.
        - **Assets Calculation**: The number of assets to return is calculated using the current exchange rate.
        - **Shares Burning**: The shares are burned from the `DelayedWithdraw` contract's holdings in the BoringVault.
        - **Asset Transfer**:
            - If `pullFundsFromVault` is `true`:
                - Assets are pulled directly from the BoringVault to the user.
            - If `false`:
                - The `DelayedWithdraw` contract transfers assets it holds to the user.
    - The user's withdrawal request is cleared.

### 4. **Cancellation**

- **Action**: Users can call `cancelWithdraw` to cancel their request before completion.
- **Outcome**:
    - Shares are transferred back to the user.
    - The withdrawal request is removed.

---

**Key Parameters and Features**

- **Withdraw Delay (`withdrawDelay`)**: The minimum time before a withdrawal can be completed.
- **Completion Window (`completionWindow`)**: Timeframe after maturity during which the withdrawal can be completed.
- **Withdraw Fee (`withdrawFee`)**: Fee percentage deducted from shares upon completion.
- **Max Loss (`maxLoss`)**: Maximum allowed exchange rate deviation between request and completion.
- **Third Party Completion**: Option for users to allow others to complete the withdrawal on their behalf.
