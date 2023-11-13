// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

import {FundMe} from "../src/fundMe.sol";

import {deployFundMe} from "../script/DeployFundMe.s.sol";

contract fundMeTest is Test {
    FundMe fundMe;
    //////////////////////////////////////////////////
    address USER = makeAddr("beef");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    ///////////////////////////////////////////////////////////
    function setUp() external {
        deployFundMe newDeploy = new deployFundMe(); //new instance of deploy scriptcontract
        fundMe = newDeploy.run(); // deploy contract returns  fundme contract with pricefeed
        vm.deal(USER, STARTING_BALANCE);
    }

    ////////////////////////////////////////////////////////////////////////////////////

    modifier funded() {
        vm.prank(USER);

        fundMe.fund{value: SEND_VALUE}();

        _;
    }

    ///////////////////////////////////////////////////////////////////////////////////
    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMessageSender() public {
        console.log(address(this));

        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testVersion() public {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundfailsWithoutEthenough() public {
        vm.expectRevert(); // expects failure next  line

        fundMe.fund();
    }

    function testFundingUpdates() public {
        vm.prank(USER); // next tx will be sent by user
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountfunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddingToFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);

        fundMe.withdraw();
    }

    /////////////////////////////////////////////////////////////////////////////////////

    function testWithdrawOnlyoneFunder() public funded {
        uint256 gasstart = gasleft();
        uint256 startingownerbalance = fundMe.getOwner().balance;

        uint256 startingFundmeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());

        fundMe.withdraw();
        ///////////////////////////

        //////////////////////////////
        uint256 endingOwnerbalance = fundMe.getOwner().balance;
        uint256 endingFundmebalance = address(fundMe).balance;

        assertEq(endingFundmebalance, 0);
        assertEq(
            startingownerbalance + startingFundmeBalance,
            endingOwnerbalance
        );
        uint256 gasend = gasleft();
        uint256 left = gasstart - gasend;
        console.log(left);
    }

    ////////////////////////////////////////////////////////////////////////////////////
    function testWithdrawManyFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingIndex = 1;

        for (uint160 i = startingIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE); // vm.prank(address(1)); vm.deal(address(1), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingownerbalance = fundMe.getOwner().balance;

        uint256 startingFundmeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);

        assert(
            startingownerbalance + startingFundmeBalance ==
                fundMe.getOwner().balance
        );
    }

    /////////////////////////////////////////////////////////////////////////
    function testWithdrawManyFundersCheaper() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingIndex = 1;

        for (uint160 i = startingIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE); // vm.prank(address(1)); vm.deal(address(1), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingownerbalance = fundMe.getOwner().balance;

        uint256 startingFundmeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdrawCheaper();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);

        assert(
            startingownerbalance + startingFundmeBalance ==
                fundMe.getOwner().balance
        );
    }
}
