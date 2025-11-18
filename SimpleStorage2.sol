// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleStorage{
    uint256[] public nums;
    uint256 public favoriteNumber;
    function store(uint256 _num) public {
        favoriteNumber = _num;
    }
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }
    function storeNums(uint256 _newNum) public {
        nums.push(_newNum);
    }
    function getNums() public view returns(uint256[] memory){
        return nums;
    }
}
