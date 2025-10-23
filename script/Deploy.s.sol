// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/GovernanceToken.sol";
import "../src/StakingContract.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        uint256 initialSupply = 1_000_000; // 1,000,000 GOV
        GovernanceToken govToken = new GovernanceToken(initialSupply);

        console.log("GovernanceToken deployed at:", address(govToken));

        uint256 rewardRate = 1e15;

        StakingContract staking = new StakingContract(address(govToken), rewardRate);
        console.log("StakingContract deployed at:", address(staking));

        govToken.transferOwnership(address(staking));

        uint256 initialRewardTokens = 100_000 * (10 ** govToken.decimals());
        govToken.transfer(address(staking), initialRewardTokens);

        console.log("Ownership transferred to StakingContract.");
        console.log("Initial GOV tokens transferred for reward pool.");

        console.log("--------------------------------------------------");
        console.log("Deployment Summary:");
        console.log("GovernanceToken:", address(govToken));
        console.log("StakingContract:", address(staking));
        console.log("Reward Rate:", rewardRate);
        console.log("Initial Supply:", initialSupply);
        console.log("--------------------------------------------------");

        vm.stopBroadcast();
    }
}
