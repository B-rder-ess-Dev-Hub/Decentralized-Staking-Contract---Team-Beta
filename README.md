# Decentralized Staking Project
![images](https://github.com/user-attachments/assets/3c5cfecb-4db4-4b7d-a486-1523ce6230db)

A decentralized staking system where users can stake native ETH and earn governance tokens as rewards. Built with Foundry and Solidity.

## 🎯 Learning Objectives

- Smart contract development with Foundry
- ERC20 token implementation
- Staking mechanisms and reward distribution
- Basic governance token concepts
- Time-based reward calculations

## 📋 Prerequisites

- Basic Solidity knowledge
- Foundry installed locally
- Understanding of ERC20 standards
- Familiarity with basic data structures

## 🏗️ Project Structure
```bash
staking-project/
├── src/
│ ├── GovernanceToken.sol
│ ├── StakingContract.sol
│ └── interfaces/
├── script/
│ ├── Deploy.s.sol
│ └── StakeAndClaim.t.sol
├── test/
│ ├── GovernanceToken.t.sol
│ └── StakingContract.t.sol
└── README.md
```


## 📝 Core Tasks

## Task 1: Governance Token Contract

**File:** `src/GovernanceToken.sol`

**Requirements:**
1. Create an ERC20 token with name "Governance Token" and symbol "GOV"
2. Implement minting functionality (only by owner/authorized addresses)
3. Include basic ERC20 functions: transfer, balanceOf, allowance, approve, transferFrom
4. Add a function to burn tokens (any holder can burn their own tokens)

**Key Data Structures:**
- `mapping(address => uint256) private _balances`
- `mapping(address => mapping(address => uint256)) private _allowances`

## Task 2: Staking Contract

**File:** `src/StakingContract.sol`

**Requirements:**
1. Accept native ETH staking
2. Track user stakes and timestamps
3. Distribute governance tokens as rewards based on staking duration
4. Allow users to unstake and claim rewards
5. Implement a reward calculation mechanism

**Key Data Structures:**
```solidity
struct StakerInfo {
    uint256 stakedAmount;
    uint256 stakingStartTime;
    uint256 lastRewardClaimTime;
    uint256 totalRewardsClaimed;
}

mapping(address => StakerInfo) public stakers;
uint256 public totalStaked;
uint256 public rewardRate; // GOV tokens per second per ETH staked
```

### Core Functions to Implement:

    stake() - Accept ETH and create staking position

    calculateRewards(address staker) - Calculate pending rewards

    claimRewards() - Distribute accumulated governance tokens

    unstake() - Return staked ETH and any pending rewards

## Task 3: Deployment Script

File: script/Deploy.s.sol

### Requirements:

- Deploy GovernanceToken contract

- Deploy StakingContract contract

- Set up initial parameters (reward rate, etc.)

- Transfer initial GOV token supply to StakingContract for rewards

## Task 4: Testing

Files: `test/GovernanceToken.t.sol` and `test/StakingContract.t.sol`

### Test Coverage Requirements:

- Token minting and burning

- Token transfers and approvals

- Staking functionality

- Reward calculation accuracy

- Unstaking with rewards

- Edge cases and security checks

# 🚀 Step-by-Step Implementation Guide

## Phase 1: Setup
bash

# Initialize Foundry project
```bash
forge init staking-project
cd staking-project
git init
# add remote repo using ssh
git remote add origin git@github.com:B-rder-ess-Dev-Hub/Decentralized-Staking-Contract---<your_team_name>

# or https
git remote add origin https://<your-personal-access-token(PAT)>@github.com:B-rder-ess-Dev-Hub/Decentralized-Staking-Contract---<your_team_name>
```

### Phase 2: Governance Token Implementation

- Create `src/GovernanceToken.sol` with basic ERC20 functions

- Add mint and burn functionality

- Write comprehensive tests in `test/GovernanceToken.t.sol`

- Run tests: `forge test --match-test testGovernance`

### Phase 3: Staking Contract Implementation

- Create `src/StakingContract.sol` with required data structures

- Implement stake function with ETH handling

- Add reward calculation logic

- Implement claimRewards and unstake functions

- Test all staking scenarios: `forge test --match-test testStaking`

### Phase 4: Integration

- Create deployment script in `script/Deploy.s.sol`

- Set reward rate (e.g., 0.001 GOV tokens per second per ETH)

- Deploy to local network: `forge script script/Deploy.s.sol --fork-url http://localhost:8545`

- Test end-to-end functionality

🧪 Testing Commands
```bash

# Run all tests
forge test

# Run specific test suite
forge test --match-test testStaking

# Test with gas reporting
forge test --gas-report

# Run tests with verbose output
forge test -vv
```

## 📤 Deployment Commands
```bash

# Deploy to local network
forge script script/Deploy.s.sol --fork-url http://localhost:8545 --broadcast

# Deploy to testnet
forge script script/Deploy.s.sol --rpc-url $TESTNET_RPC --private-key $PRIVATE_KEY --broadcast
```
## 🔒 Security Considerations

    Use Checks-Effects-Interactions pattern

    Prevent reentrancy attacks

    Validate all user inputs

    Implement proper access controls

    Test edge cases thoroughly

## 🎯 Key Algorithms
Reward Calculation Algorithm
```solidity

function calculateRewards(address staker) public view returns (uint256) {
    StakerInfo memory info = stakers[staker];
    if (info.stakedAmount == 0) return 0;
    
    uint256 timeStaked = block.timestamp - info.lastRewardClaimTime;
    return (timeStaked * info.stakedAmount * rewardRate) / 1e18;
}
```
## 📚 Resources

[Foundry Documentation](https://getfoundry.sh/)

[Solidity Documentation](https://docs.soliditylang.org/en/v0.8.30/)

[ERC20 Standard](https://eips.ethereum.org/EIPS/eip-20)
