const ItemManager = artifacts.require("./ItemManager.sol");

contract("ItemManager", accounts => {
    it("...Should Be able to add an item", async function(){
        const ItemManagerInstance = await ItemManager.deployed();
        const itemName = "Picture1";
        const itemPrice = 1000;

        let result = await ItemManagerInstance.createItem(itemName, itemPrice, {from: accounts[0]});
        assert.equal(result.logs[0].args._itemIndex, 0, "Not first time");

        const item = await ItemManagerInstance.items(0);
        assert.equal(item.name, itemName, "Different Identifier");
    })
});