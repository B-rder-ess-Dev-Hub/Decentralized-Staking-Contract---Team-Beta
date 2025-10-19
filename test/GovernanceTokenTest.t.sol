// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {GovernanceToken} from "../src/GovernanceToken.sol";

contract GovernanceTokenTest is Test {
    GovernanceToken govToken;
    address owner = address(this);
    address user1 = address(0x1);
    address user2 = address(0x2);

    function setUp() public {
        govToken = new GovernanceToken(1000);
    }

   function testMint() public {
       govToken.mintToken(user1, 200 ether);
       assertEq(govToken.balanceOf(user1), 200 ether);
    }


    function testBurn() public {
        uint256 initialBalance = govToken.balanceOf(owner);

        govToken.burn(100 ether);
        assertEq(govToken.balanceOf(owner), initialBalance - 100 ether);
        assertEq(govToken.totalSupply(), 900 ether);
    }
}
