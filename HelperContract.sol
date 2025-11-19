// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MyContract{
    // uint256 public sqOfNum;
    function squareOfNum(uint256 _sqOfNum) public pure returns(uint256){
       return helper(_sqOfNum);
    }


}
function helper(uint256 x) pure returns(uint256) {
    return x*x;
}

function helper2(address addr) pure returns(bool){
    // if(addr != address(0)){
    //     return true;
    // }else{
    //     return false;
    // }
    return addr != address(0);

}