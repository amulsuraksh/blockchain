// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract bank{
    uint balance;
    
    address public owner;
    constructor(){
        owner = msg.sender;
    }

function dep() external payable{
    require(msg.sender==owner&& msg.value!=0 ,"not valid");
    balance+=msg.value;
      
    }
function draw()public{
    require(msg.sender==owner,"not possible" );
    payable(msg.sender).transfer(balance);
    balance=0;
}
}