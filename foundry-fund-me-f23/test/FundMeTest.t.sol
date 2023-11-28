// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        // us -> FundMeTest -> FundMe
        fundMe = new FundMe(); // a variable called fundMe of type FundMe will be a new contract FundMe
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        // Asegurarse de que i_owner es una función pública que devuelve una dirección
        address owner = fundMe.i_owner(); 

        assertEq(owner, address(this)); // The owner is FundMeTest
    }
}