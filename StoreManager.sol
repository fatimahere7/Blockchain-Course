// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {SimpleStorage} from "./SimpleStorage2.sol";

contract StorageManager{
    address public owner;
    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner(){
        require(msg.sender == owner, "you are not the owner!");
        _;
    }
    SimpleStorage[] public simpleStorageArray;
    
    event deloyedContract(address newContarctAddress, uint256 index);
    event valueStoredInContract(uint256 index, uint256 val, address contractAddress);
    event valueUpdatedInContract(uint256 index , uint val);

    function deplyNewSimpleStorage() public onlyOwner{
        SimpleStorage newSimp = new SimpleStorage();
        simpleStorageArray.push(newSimp);
        
        emit deloyedContract(address(newSimp),simpleStorageArray.length-1 );
    }
    function setManagerStore(uint _simpleStorageIndex , uint256 _newSimpleStorageVal) public onlyOwner{
        require(simpleStorageArray.length > 0 , "No Contract Deployed yet");
        require(getManagerReterieve(_simpleStorageIndex) == 0 ,"There Already some value available.");
        SimpleStorage mySimpleStorage = simpleStorageArray[_simpleStorageIndex];
        mySimpleStorage.store(_newSimpleStorageVal);
        emit valueStoredInContract(_simpleStorageIndex, _newSimpleStorageVal, address(mySimpleStorage));
    }

    function getManagerReterieve(uint256 _simpleStorageIndex) public view onlyOwner returns(uint256) {
        require(simpleStorageArray.length > _simpleStorageIndex , "Out of Bound, doesnt exist.");
        return simpleStorageArray[_simpleStorageIndex].retrieve();
    }

    function updateSSValue(uint256 _index , uint256 updatedVal) public onlyOwner{
        require(simpleStorageArray[_index].retrieve() != 0 ,"No value yet");
        simpleStorageArray[_index].store(updatedVal);
        emit valueUpdatedInContract(_index, updatedVal);
    }
}