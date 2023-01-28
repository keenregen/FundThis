// Price Converter Library
// Libraries cannot have any state vars nor cannot send ETH

// SPDX-License-Identifier: Blank

pragma solidity ^0.8.8;

import "./node_modules/@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverterLib {
    
    function getPrice() internal view returns (uint256) {
        // abi
        // contract address 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e  (eth / usd goerli testnet)
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (,int256 price,,,) = priceFeed.latestRoundData();
        // ETH in usd (8 decimal places, should be 18 dec places as ETH and should be uint256 as ETH)
        return uint256(price) * 1e10;
    }   

    function getConverted(uint256 ethAmount) internal view returns (uint256){
        // ETH in USD
        uint256 ethAmountInUsd = (getPrice() * ethAmount) / 1e18;
        return ethAmountInUsd;
    }


}