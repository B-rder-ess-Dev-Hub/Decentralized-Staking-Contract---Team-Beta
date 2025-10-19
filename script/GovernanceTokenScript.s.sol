// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {GovernanceToken} from "../src/GovernanceToken.sol";

contract GovernanceTokenScript is Script {

    function run()external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        GovernanceToken governanceToken = new GovernanceToken(900);
        console2.log("Governance Token deployed at:", address(governanceToken));

        vm.stopBroadcast();
    }
}
