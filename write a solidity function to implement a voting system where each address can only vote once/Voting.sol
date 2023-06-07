//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    mapping(address => bool) private voters;

    uint256 public yesVoted;
    uint256 public noVoted;

    function vote(bool _vote) public {
        require(!voters[msg.sender],"You can only vote once");
        voters[msg.sender] = true;
        if(_vote){
            yesVoted += 1;
        }else{
            noVoted += 1;
        }
    }

}