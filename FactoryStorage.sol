// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {SimpleStorage} from "./SimpleStorage.sol";
contract FactoryStorage{
    SimpleStorage[] public simpleStorage;
    function createSimpleStorageContract() public {
        SimpleStorage newSimSto = new SimpleStorage();
        simpleStorage.push(newSimSto);
    }

    function sfStore(uint _simpleStorageIndex , uint256 _newSimpleStorage) public {
        //adress and ABI
        SimpleStorage mySimpleStorage = simpleStorage[_simpleStorageIndex];
        mySimpleStorage.setNumber(_newSimpleStorage);
    }
    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
        // SimpleStorage mySimpleStorage = simpleStorage[_simpleStorageIndex];
        return simpleStorage[_simpleStorageIndex].retrieve();
    }
} 