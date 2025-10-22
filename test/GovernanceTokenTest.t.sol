// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/GovernanceToken.sol";
import "../src/StakingContract.sol";

contract StakingContractTest is Test {
    GovernanceToken govToken;
    StakingContract staking;

    address user1 = address(0xA11CE);
    address user2 = address(0xB0B);

    uint256 constant INITIAL_SUPPLY = 1_000_000;
    uint256 constant REWARD_RATE = 1000;

    function setUp() public {
        govToken = new GovernanceToken(INITIAL_SUPPLY);
        staking = new StakingContract(address(govToken), REWARD_RATE);
        govToken.transferOwnership(address(staking));
        vm.deal(user1, 10 ether);
        vm.deal(user2, 5 ether);
    }

    function testStakeIncreasesTotalStaked() public {
        uint256 amount = 2 ether;
        vm.startPrank(user1);
        staking.stake{value: amount}();
        vm.stopPrank();
        (uint256 staked, uint256 pending, ) = staking.getStakerInfo(user1);
        assertEq(staked, amount);
        assertEq(pending, 0);
        assertEq(staking.totalStaked(), amount);
    }

    function testRewardsAccumulateOverTime() public {
        uint256 amount = 1 ether;
        vm.startPrank(user1);
        staking.stake{value: amount}();
        vm.stopPrank();
        vm.warp(block.timestamp + 3600);
        (, uint256 pending, ) = staking.getStakerInfo(user1);
        uint256 expected = (amount * REWARD_RATE * 3600) / 1e18;
        assertApproxEqAbs(pending, expected, 1e9);
    }

    function testClaimRewardsMintsGovTokens() public {
        uint256 amount = 1 ether;
        vm.startPrank(user1);
        staking.stake{value: amount}();
        vm.warp(block.timestamp + 1000);
        staking.claimRewards();
        vm.stopPrank();
        uint256 balance = govToken.balanceOf(user1);
        assertGt(balance, 0);
    }

    function testUnstakeReturnsEthAndRewards() public {
        uint256 amount = 1 ether;
        vm.startPrank(user1);
        staking.stake{value: amount}();
        vm.warp(block.timestamp + 500);
        uint256 beforeEth = user1.balance;
        staking.unstake();
        vm.stopPrank();
        uint256 afterEth = user1.balance;
        assertGt(afterEth, beforeEth);
        assertGt(govToken.balanceOf(user1), 0);
    }

    function testOnlyOwnerCanUpdateRewardRate() public {
        uint256 newRate = 5000;
        staking.setRewardRate(newRate);
        assertEq(staking.rewardRate(), newRate);
        vm.prank(user1);
        vm.expectRevert();
        staking.setRewardRate(9999);
    }

    function testMultipleUsersStakeAndAccrueRewards() public {
        vm.startPrank(user1);
        staking.stake{value: 2 ether}();
        vm.stopPrank();
        vm.startPrank(user2);
        staking.stake{value: 1 ether}();
        vm.stopPrank();
        vm.warp(block.timestamp + 1000);
        (, uint256 reward1, ) = staking.getStakerInfo(user1);
        (, uint256 reward2, ) = staking.getStakerInfo(user2);
        assertGt(reward1, reward2);
    }

    function testUnstakeWithoutStakeReverts() public {
        vm.expectRevert("Nothing to unstake");
        vm.prank(user1);
        staking.unstake();
    }

    function testClaimBeforeStakeReverts() public {
        vm.expectRevert("No active stake");
        vm.prank(user1);
        staking.claimRewards();
    }
}
