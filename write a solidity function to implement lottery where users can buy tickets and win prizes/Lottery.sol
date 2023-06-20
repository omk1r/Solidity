//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract lottery{
    address payable[] public players;
    address public manager;
    address payable public winner;

    constructor(){
        manager = msg.sender;
    }

    function buyTickets() external payable {
        require(msg.value == 1 wei,"send 0.1 ether to buy ticket");
        players.push(payable(msg.sender));
    }

    function random() internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,players.length)));
    }

    function pickWinner() public payable {
        require(msg.sender == manager,"You are not the owner");
        require(players.length >= 3,"Not enough players");
        uint r = random();
        uint index = r%players.length;
        winner = players[index];
        winner.transfer(1 wei);
        players = new address payable[](0);
    }

    function allPlayers() public view returns(address payable[] memory) {
        return players;
    }
}