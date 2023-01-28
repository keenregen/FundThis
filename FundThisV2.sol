// get funds from blch users
// set a min funding value in usd
// keep funder addresses and fund amounts
// withdraw funds

// v2 with Price Converter Library usage

// SPDX-License-Identifier: Blank

pragma solidity ^0.8.8;

import "./PriceConverterLib.sol";


contract FundThisV2 {

    using PriceConverterLib for uint256;

    uint256 public minUsd = 1 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    
    address deployer;

    // called when the contract is deployed
    constructor() {
        deployer = msg.sender;
    }


    function fund() public payable {
        // set min funding value with require keyword
        // if require condition is not met, the ops before are undone and gas remaining is sent back
        // msg.value : how much money is added to be sent
        require(msg.value.getConverted() >= minUsd, "min $1 is needed"); // 1e18 = 1 * 10 * 10**18 wei = 1 ETH
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyDeployer {

        // withdraw the funds (msg.sender should be casted to payable)
        // 1. Method: Transfer (max 2300 gas; if fails reverts the transaction)
        // payable(msg.sender).transfer(address(this).balance);
        // 2. Method: Send (max 2300 gas; if fails returns a bool)
        // bool sendingSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendingSuccess, "Sending failed");
        // 3. Method: Call (forward all gas or set gas, returns bool) (recommended)
        (bool callSuccess, /* bytes memory dataReturned */) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Sending failed");

        // reset the amounts funded
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            addressToAmountFunded[funders[funderIndex]] = 0;
        }

        // reset the funders array
        funders = new address[](0);
    }

    modifier onlyDeployer {
        require(msg.sender == deployer, "Sender must be contract deployer.");
        _;
    }

}
