// get funds from blch users to this contract
// withdraw the funds
// set a min funding value in usd

// SPDX-License-Identifier: Blank

// import the interface
import "./node_modules/@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

pragma solidity ^0.8.8;

// 1e18 = 1 * 10 * 10**18 wei = 1 ETH

contract FundThis {

    uint256 public minUsd = 1 * 1e18;

    function fundThis() public payable {
        // set min funding value with require keyword
        // if require condition is not met, the ops before are undone and gas remaining is sent back
        // msg.value : how much money is added to be sent
        require(getConverted(msg.value) >= minUsd, "min $1 is needed"); 
    }

    function getPrice() public view returns (uint256) {
        // abi
        // contract address 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e  (eth / usd goerli testnet)
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (,int256 price,,,) = priceFeed.latestRoundData();
        // ETH in usd (8 decimal places, should be 18 dec places as ETH and should be uint256 as ETH)
        return uint256(price) * 1e10;
    }   

    function getConverted(uint256 ethAmount) public view returns (uint256){
        // ETH in USD
        uint256 ethAmountInUsd = (getPrice() * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}