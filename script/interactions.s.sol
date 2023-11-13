//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/fundMe.sol";

contract fundFundMe is Script {
    uint256 public SEND_VALUE = 0.1 ether;

    function fundContract(address recent) public {
        vm.startBroadcast();
        FundMe(payable(recent)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    ///////////////////////////////////////////////////////////////////////////////
    function run() external {
        address mostRecent = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );

        fundContract(mostRecent);
    }
}

contract withdrawFundMe is Script {
    //////////////////////////////////////
    function withdrawContract(address recent) public {
        vm.startBroadcast();
        FundMe(payable(recent)).withdraw();
        vm.stopBroadcast();
    }

    ///////////////////////////////////////////////////////////////////////////
    function run() external {
        address mostRecent = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );

        withdrawContract(mostRecent);
    }
}
