// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract todo{
    address public owner;
    struct todolist{
        string name;
        bool completed;
    }
    constructor(){
        owner=msg.sender;
    }
    modifier isOwner(){
        require(msg.sender==owner,"no access");
       _;
    }
    todolist[] public todos;
    function create(string calldata _name)external isOwner(){
        todos.push(todolist({
            name:_name,
            completed:false
        }));
    }
    function update(uint _index,string calldata _name)external isOwner(){
        todos[_index].name=_name;
    }
    function toggleCompleted(uint _index) external isOwner() {
        todos[_index].completed = !todos[_index].completed;
        }
}