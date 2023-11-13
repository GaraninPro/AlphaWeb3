// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

import {FundMe} from "../../src/fundMe.sol";

import {deployFundMe} from "../../script/DeployFundMe.s.sol";
import {fundFundMe, withdrawFundMe} from "../../script/interactions.s.sol";

contract TestIntegration is Test {
    FundMe fundMe;

    //////////////////////////////////////////////////
    // address USER = makeAddr("beef");
    // uint256 constant SEND_VALUE = 0.1 ether;
    // uint256 constant STARTING_BALANCE = 10 ether;

    ///////////////////////////////////////////////////////////
    function setUp() external {
        deployFundMe newDeploy = new deployFundMe(); //new instance of deploy scriptcontract
        fundMe = newDeploy.run(); // deploy contract returns  fundme contract with pricefeed
        // vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        fundFundMe donate = new fundFundMe();

        donate.fundContract(address(fundMe));
        /////////////////////////////////////////

        withdrawFundMe getRich = new withdrawFundMe();

        getRich.withdrawContract(address(fundMe));
        /////////////////////////////////////////////////

        assert(address(fundMe).balance == 0);
    }
}
