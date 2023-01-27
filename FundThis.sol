// get funds from blch users to this contract
// withdraw the funds
// set a min funding value in usd

// SPDX-License-Identifier: Blank

pragma solidity ^0.8.8;

contract FundThis {

    function fundThis() public payable {
        // set min funding value with require keyword
        // if require condition is not met, the ops before are undone and gas remaining is sent back
        // msg.value : how much money is added to be sent
        require(msg.value > 1e18, "min 1 ETH is needed"); // 1e18 = 1 * 10 * 10**18 wei = 1 ETH

    }
}