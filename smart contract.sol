// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public manager; // Address of the contract manager
    address[] public players; // Array to store participant addresses

    constructor() {
        manager = msg.sender; // Set the deployer's address as the manager
    }

    function enter() public payable {
        require(msg.value > 0.01 ether, "Minimum entry fee required"); // Require minimum entry fee
        players.push(msg.sender); // Add participant's address to the players array
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players))); // Generate pseudo-random number
    }

    function pickWinner() public restricted {
        uint index = random() % players.length; // Select random index from players array
        address winner = players[index]; // Get the address of the winner
        payable(winner).transfer(address(this).balance); // Transfer contract balance to the winner
        players = new address [] (0); // Reset the players array
    }

    modifier restricted() {
        require(msg.sender == manager, "Only the manager can call this function"); // Only the manager can call this function
        _;
    }

    function getPlayers() public view returns (address[] memory) {
        return players; // Return the array of player addresses
    }
}
