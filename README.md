# Governance Token (GOV)

An ERC20 Governance Token built using OpenZeppelin.

## Features

- Minting (onlyOwner)
- Burning (any holder)
- Transfer, Approve, Allowance (ERC20 standard)

## Deployment Info

- Network: Sepolia Testnet
- Contract Address: 0xdDF4861863F6Be4d168F5Fd42D3f7fd8642bc097
- Verified on: [Sepolia Etherscan](https://sepolia.etherscan.io/address/0xdDF4861863F6Be4d168F5Fd42D3f7fd8642bc097)

## Commands

```bash
forge build
forge test --vv
forge create src/GovernanceToken.sol:GovernanceToken --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY
forge script script/GovernanceTokenScript.s.sol --rpc-url $SEPOLIA_RPC_URL--broadcast --verify
forge flatten src/GovernanceToken.sol > FlattenedGOV.sol

