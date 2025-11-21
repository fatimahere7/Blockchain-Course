// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {PriceConverter} from "./PriceConverter.sol";

contract SplitEtherContract{
    using PriceConverter for uint256;
    address payable[] recipents;


    function addRecipents(address payable _person) public {
        recipents.push(_person);
        
    }

    function splitEth() public payable {
        require(msg.value % recipents.length == 0 , "ETH not divisible");
        uint256 val = msg.value;
        uint256 share = val/recipents.length;
        uint256 leftover = msg.value - (share * recipents.length);
        for(uint256 i = 0;i < recipents.length;i++){
            (bool callSuccess,)= payable(recipents[i]).call{value : share}("");
            require(callSuccess, "Transfer failed");
        }
        if (leftover > 0){
            (bool success,) = payable(msg.sender).call{value : leftover}("");
            require(success, "Leftover transfer failed");
        }

    }
    
   
}