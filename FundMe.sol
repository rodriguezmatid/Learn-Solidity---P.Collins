// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    // two keywords that make that your variables can't be change (constant and immutable)
    // Immutable makes you save gas than don't using it
    uint256 public constant MINIMUM_USD = 5e18;
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;
    constructor() {
        i_owner = msg.sender;
    }

    // payable: make the function can receive blockchain native token
    function fund() public payable {
        // require: force the tx to do something and fail if that wasn't done
        require(msg.value.getConversionRate() > MINIMUM_USD, "didn't send enough ETH"); 
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    // Revert undo any actions that have been done, and send the remaining gas back

    function withdraw() public onlyOwner {
        
        // starting index, ending index, step amount (++ = +1)
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex ++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0; // reset to 0 because we are withdrawing
        }

        // reset the array
        funders = new address[](0);

        //withdraw the funds, 3 ways:
        // transfer (2300 gas, if fails => throws error)
        payable(msg.sender).transfer(address(this).balance); //msg.sender = address --> payable(msg.sender) = payable address
        // send (2300 gas, if fails => returns bool)
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess = "Send failed");
        // call (forward all gas or set gas, returns bool)
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {
        // execute first the require and then the code in the function
        // require(msg.sender == i_owner, NotOwner());
        if(msg.sender != i_owner) {revert NotOwner();}
        _;
        //
    }
    
    // special functions. If data is sent with a tx and no function was specified, the tx will default to the fallback function.
    // If data is empty, it'll call the receive function
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}