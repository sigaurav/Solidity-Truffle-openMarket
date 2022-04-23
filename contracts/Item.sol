// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./ItemManager.sol";

contract Item{
    uint public priceWei;
    uint public pricePaid;
    uint public index;

    ItemManager parentContract;

    constructor (ItemManager _parentContract, uint _priceWei, uint _index) {
        priceWei = _priceWei;
        index = _index;
        parentContract = _parentContract;
    }



    receive () external payable {
        require (pricePaid == 0, "Item is already paid for");
        require (priceWei == msg.value, "!!!Incorrect Amount!!!");
        (bool sent, ) = address(parentContract).call{value: msg.value}(abi.encodeWithSignature("initPayment(uint256)", index));
        require(sent, "Transaction Failed");
        pricePaid = msg.value;
    }
}