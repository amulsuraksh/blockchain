// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract amul{
    uint num1;
    uint num2;
    function getValue(uint a,uint b) public {
        num1 = a;
        num2 = b;
    }
    function add() view public returns (uint){
        return num1+num2;
    }
    function sub() view public returns (uint){
        return num1-num2;
    }
}