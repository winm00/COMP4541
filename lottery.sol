// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Lottery {
    address public owner; // Contract owner
    address[] public players; // List of participants
    uint256 public studentId; // Student ID for testing purposes

    event LotteryEntered(address indexed player, uint256 amount);
    event WinnerPicked(address indexed winner, uint256 prize);

    constructor(uint256 _studentId) {
        owner = msg.sender; // Set the deployer as the owner
        studentId = _studentId; // Store the student ID
    }

    // Enter the lottery
    function enter() public payable {
        require(msg.value == 0.001 ether, "Entry fee is 0.001 ETH");
        players.push(msg.sender); // Add the sender to the players list
        emit LotteryEntered(msg.sender, msg.value);
    }

    // Get all players
    function getPlayers() public view returns (address[] memory) {
        return players;
    }

    // Pick a random winner (only owner can call)
    function pickWinner() public onlyOwner {
        require(players.length > 0, "No players in the lottery");

        uint256 winnerIndex = random() % players.length;
        address winner = players[winnerIndex];

        uint256 prize = address(this).balance;
        payable(winner).transfer(prize); // Transfer the prize

        emit WinnerPicked(winner, prize);

        // Reset lottery for the next round
        players = new address[](0);
    }

    // Generate a random number
    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, players)));
    }

    // Restricted access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}
