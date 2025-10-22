// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import {GovernanceToken} from "./GovernanceToken.sol";

contract StakingContract is Ownable, ReentrancyGuard {
    GovernanceToken public govToken;
    uint256 public rewardRate;
    uint256 public totalStaked;

    struct StakerInfo {
        uint256 stakedAmount;
        uint256 stakingStartTime;
        uint256 lastRewardClaimTime;
        uint256 totalRewardsClaimed;
    }

    mapping(address => StakerInfo) public stakers;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 rewardAmount);
    event RewardRateUpdated(uint256 newRate);

    constructor(address _govToken, uint256 _rewardRate) Ownable(msg.sender) {
        require(_govToken != address(0), "Invalid token address");
        govToken = GovernanceToken(_govToken);
        rewardRate = _rewardRate;
    }

    function stake() external payable nonReentrant {
        require(msg.value > 0, "Must stake more than 0");
        StakerInfo storage staker = stakers[msg.sender];
        if (staker.stakedAmount > 0) {
            uint256 pendingReward = calculateRewards(msg.sender);
            if (pendingReward > 0) {
                govToken.mintToken(msg.sender, pendingReward);
                staker.totalRewardsClaimed += pendingReward;
                emit RewardClaimed(msg.sender, pendingReward);
            }
        } else {
            staker.stakingStartTime = block.timestamp;
        }
        staker.stakedAmount += msg.value;
        staker.lastRewardClaimTime = block.timestamp;
        totalStaked += msg.value;
        emit Staked(msg.sender, msg.value);
    }

    function calculateRewards(address stakerAddr) public view returns (uint256) {
        StakerInfo memory staker = stakers[stakerAddr];
        if (staker.stakedAmount == 0) return 0;
        uint256 timeElapsed = block.timestamp - staker.lastRewardClaimTime;
        uint256 reward = (staker.stakedAmount * rewardRate * timeElapsed) / 1e18;
        return reward;
    }

    function claimRewards() external nonReentrant {
        StakerInfo storage staker = stakers[msg.sender];
        require(staker.stakedAmount > 0, "No active stake");
        uint256 pendingReward = calculateRewards(msg.sender);
        require(pendingReward > 0, "No rewards available");
        staker.lastRewardClaimTime = block.timestamp;
        staker.totalRewardsClaimed += pendingReward;
        govToken.mintToken(msg.sender, pendingReward);
        emit RewardClaimed(msg.sender, pendingReward);
    }

    function unstake() external nonReentrant {
        StakerInfo storage staker = stakers[msg.sender];
        require(staker.stakedAmount > 0, "Nothing to unstake");
        uint256 stakedAmount = staker.stakedAmount;
        uint256 pendingReward = calculateRewards(msg.sender);
        staker.stakedAmount = 0;
        staker.stakingStartTime = 0;
        staker.lastRewardClaimTime = block.timestamp;
        totalStaked -= stakedAmount;
        if (pendingReward > 0) {
            staker.totalRewardsClaimed += pendingReward;
            govToken.mintToken(msg.sender, pendingReward);
            emit RewardClaimed(msg.sender, pendingReward);
        }
        (bool success, ) = payable(msg.sender).call{value: stakedAmount}("");
        require(success, "ETH transfer failed");
        emit Unstaked(msg.sender, stakedAmount);
    }

    function setRewardRate(uint256 _newRate) external onlyOwner {
        rewardRate = _newRate;
        emit RewardRateUpdated(_newRate);
    }

    function withdrawEth(uint256 _amount) external onlyOwner {
        require(_amount <= address(this).balance, "Insufficient balance");
        (bool success, ) = payable(owner()).call{value: _amount}("");
        require(success, "Withdraw failed");
    }

    function getStakerInfo(address _user)
        external
        view
        returns (
            uint256 stakedAmount,
            uint256 pendingRewards,
            uint256 totalRewardsClaimed
        )
    {
        StakerInfo memory staker = stakers[_user];
        stakedAmount = staker.stakedAmount;
        pendingRewards = calculateRewards(_user);
        totalRewardsClaimed = staker.totalRewardsClaimed;
    }

    receive() external payable {}
}
