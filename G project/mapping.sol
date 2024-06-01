// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract cal {
    uint public num1;
    uint public num2;
   uint public total1;
    uint public total;
    mapping (address=>bool) public addradd;
    mapping (address=>bool) public addrsub;
    function getValues(uint a,uint b) public {
        num1=a;
        num2=b;
    }
    
    function addaddr(address addres) public {
        require(addradd[addres]=true,"invalid");
        total=num1+num2;
    }
    function subaddr(address addres) public {
        require(addrsub[addres]=true,"invalid");
        total1=num1-num2;
    }
}