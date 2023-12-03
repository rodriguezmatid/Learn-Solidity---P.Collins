// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        // us -> FundMeTest -> FundMe
        // fundMe = new FundMe(); // a variable called fundMe of type FundMe will be a new contract FundMe
        DeployFundMe deployFundMe = new DeployFundMe(); // you are deploying a new contract
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        // Asegurarse de que i_owner es una función pública que devuelve una dirección
        address owner = fundMe.i_owner(); 

        assertEq(owner, msg.sender); // The owner is FundMeTest
    }

    // What can we do to work with addresses outside our system?
    // 1. Unit. Testing a specific part of our code
    // 2. Integration. Testing how our code works with other parts of our code
    // 3. Forked. Testing our code on a simulated real environment
    // 4. Testing our code in a real environment that is not prod

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); //hey, the next line, should revert!
        // expect this line to fail, if not, the test failed
        fundMe.fund(); // send 0 value
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // the next tx will be sent by user
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }
}