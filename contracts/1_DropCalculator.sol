// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "hardhat/console.sol";


/**
 * @title Item data
 */
struct Item {
    string name;
    uint count;
}


/**
 * @title Drop calculator
 */
contract DropCalculator {

    address internal owner;
    string[] internal itemNames = ["Sword", "Dagger", "Bow", "Helmet", "Gloves", "Ring", "HP Potion", "MP Potion", "Apple"];
    uint public dropRate;

    /**
     * @dev Set contract deployer as owner
     */
    constructor() {
        owner = msg.sender;
        dropRate = 30; // 30%
    }

    /**
     * @dev Change drop rate (0 - 100)
     */
    function setDropRate(uint newDropRate) public {
        require(msg.sender == owner, "Caller is not owner");
        require(newDropRate <= 100 , "Invalid drop rate");

        dropRate = newDropRate;
    }

    /**
     * @dev Return dropped items
     */
    function getDrop() external view returns (Item[] memory) {
        Item[] memory items = new Item[](itemNames.length + 1);

        uint itemsCount = 0;
        uint goldRate = dropRate * 50;
        uint goldCount = random(itemsCount) % goldRate;
        if (goldCount > 0) {
            items[itemsCount] = Item({ name: "Gold", count: goldCount });
            itemsCount++;
        }

        for (uint i = 0; i < itemNames.length; i++) {
            uint itemResult = random(itemsCount) % 100;
            if (itemResult < dropRate) {
                items[itemsCount] = Item({ name: itemNames[i], count: itemResult });
                itemsCount++;
            }
        }

        Item[] memory result = new Item[](itemsCount);
        for (uint r = 0; r < itemsCount; r++) {
            result[r] = items[r];
        }

        return result;
    }

    /**
     * @dev Helper function that returns a big random integer
     */
    function random(uint seed) internal view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, seed)));
    }
}
