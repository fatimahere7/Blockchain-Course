
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();
error NotEnoughETH();

contract FundMe{
    using PriceConverter for uint256; 
    uint256 public constant MINIMUM_USD = 5e18; //gas optimized using constant

    
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public immutable i_owner;
    constructor(){
        i_owner = msg.sender;
    }


    modifier callMeRightAway() {
        // require(msg.sender == i_owner , "Only owner have access to this");
        if(msg.sender != i_owner){
            revert NotOwner();
        }
        _;
    }


    function fund() public payable{
        //Allow users to send $
        //Have a minimum $ sent
        //how we send Eth to this contract? 
        //require(msg.value.getConversionRate() >= MINIMUM_USD , "didnt send enough ETH");  
        if (msg.value.getConversionRate() < MINIMUM_USD){
            revert NotEnoughETH();
        }
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }



    function withdraw() public callMeRightAway{
        for(uint256 funderIndex; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //reset the funders array
        funders = new address[](0);

        //three differe way to transfer the find
        //transfer , Send , Call

         //transfer
        // payable(msg.sender).transfer(address(this).balance);


        //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess , "Sending Failed");


        //call
        //returns two variable bool , return value from functions
        (bool callSuccess ,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess , "Call failed");
    } 

    // what if someone send Eth to contract without calling the fund Function?
    //Recieve
    //fallback
    receive() external payable {
        fund();
    }
    fallback() external payable {
        fund();
    }

}
























// interface AggregatorV3Interface {
//   function decimals() external view returns (uint8);
//   function description() external view returns (string memory);
//   function version() external view returns (uint256);

//   function getRoundData(uint80 _roundId)
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,  // price 
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );

//   function latestRoundData()
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );
// }