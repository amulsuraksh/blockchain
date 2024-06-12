// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract crowdfunding{
    address public owner;
    uint public minamnt;
    uint public goal;
    uint public fundsraised;
    uint public timeperiod;
    uint public noOfFunders;
    mapping(address=>uint) public funders;
    constructor(uint g,uint tp ){
        owner=msg.sender;
        goal=g;
        timeperiod=block.timestamp+tp;
        minamnt=1000 wei;
    }
    function contribution() public payable  {
        require(msg.value>=minamnt && timeperiod>=block.timestamp,"less funds");
        if (funders[msg.sender]==0){
            noOfFunders++;
        }
        funders[msg.sender]+=msg.value;
        fundsraised+=msg.value;
    }
    function getrefund()public{
        payable(msg.sender).transfer(funders[msg.sender]);
        fundsraised-=funders[msg.sender];
        funders[msg.sender]=0;
        noOfFunders--;
    }
        struct Requests{
        string about;
        uint amnt;
        address payable receiver;
        uint noofvoters;
        mapping(address => bool) votes;
        bool completed;
    }
    mapping(uint => Requests) public AllRequests;
    uint public numReq;
    function createRequest(string memory _description,
                            uint _amount,
                            address payable _receiver)public {
        Requests storage newReqest = AllRequests[numReq];
        numReq++;
        newReqest.about = _description;
        newReqest.amnt = _amount;
        newReqest.receiver = _receiver;
        newReqest.completed = false;
        newReqest.noofvoters = 0;
        }
    function votingForRequest(uint reqNum)  public   {
        require(funders[msg.sender] > 0, "Not a Funder!");
        Requests storage thisRequest = AllRequests[reqNum];
        require(thisRequest.votes[msg.sender] == false, "Already Voted!");
        thisRequest.votes[msg.sender]=true;
        thisRequest.noofvoters++;
    }
    function makePayment(uint reqNum)  public {
        require(msg.sender==owner,"invalid");
        Requests storage thisRequest = AllRequests[reqNum];
        require(thisRequest.noofvoters >= noOfFunders/2,"invalid");
        thisRequest.receiver.transfer(thisRequest.amnt);
        thisRequest.completed = true;
    }
}