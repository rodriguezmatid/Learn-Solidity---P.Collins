// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        // us -> FundMeTest -> FundMe
        // fundMe = new FundMe(); // a variable called fundMe of type FundMe will be a new contract FundMe
        DeployFundMe deployFundMe = new DeployFundMe(); // you are deploying a new contract
        fundMe = deployFundMe.run();
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
}