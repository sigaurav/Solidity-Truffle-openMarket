// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable{

    enum SupplyState{Created, Paid, Delivered}
    event SupplyLog(uint _itemIndex, uint _step, address _itemAddress, address _owner);

    struct S_Item{
        Item item;
        string name;
        uint price;
        address owner;
        ItemManager.SupplyState state;
    }

    mapping(uint => S_Item) public items;
    uint itemIndex;
    
    function createItem (string memory _itemName, uint _itemPrice) public onlyOwner{  
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex].item = item;
        items[itemIndex].name = _itemName;
        items[itemIndex].price = _itemPrice;
        items[itemIndex].owner = owner();
        items[itemIndex].state = SupplyState.Created;
        
        emit SupplyLog(itemIndex, uint(items[itemIndex].state), address(item), items[itemIndex].owner );
        itemIndex++;
        
        
    }

    function initPayment(uint _itemIndex) public payable {
        require(items[_itemIndex].price == msg.value, "!!!Incorrect Amount!!!");
        require(items[_itemIndex].state == SupplyState.Created, "!!!Not available!!!");
        items[_itemIndex].state = SupplyState.Paid;

        emit SupplyLog(_itemIndex, uint(items[_itemIndex].state), address(items[_itemIndex].item), items[_itemIndex].owner );
    }

    function initDelivery(uint _itemIndex, address _newOwner) public onlyOwner {
        require(items[_itemIndex].state == SupplyState.Paid, "!!!Pending Payment!!!");
        items[_itemIndex].owner = _newOwner;
        items[_itemIndex].state = SupplyState.Delivered;
        emit SupplyLog(_itemIndex, uint(items[_itemIndex].state), address(items[_itemIndex].item), items[_itemIndex].owner) ;
    }

    fallback () external payable {

    }

    receive () external payable {

    }
}