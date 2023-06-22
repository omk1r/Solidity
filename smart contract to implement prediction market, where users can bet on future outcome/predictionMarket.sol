//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract Market{
    address manager;

    mapping(address => bool) public predictions;
    

    bool public outcome;
    uint256 public endTime;
    bool setClaimWinnigs;
    uint256 totalYesbets;
    uint256 totalNobets;
    uint256 winningAmount;
    mapping(address => uint256) public userWinnings;

    constructor(){
        manager = msg.sender;
        endTime = block.timestamp + 2 minutes;
        setClaimWinnigs = false;
    }
    

    function predict(bool _predict) public payable {
        require(msg.value == 10 wei,"entry fees to prediction market is 10 wei");
        require(block.timestamp <= endTime,"time to predict the outcome is over");
        predictions[msg.sender] = _predict;
        if(_predict){
            totalYesbets += 1;
        }else{
            totalNobets += 1;
        }
    }

    function updateOutcome(bool _outcome) public {
        require(msg.sender == manager,"You don't have the permission to update the outcome");
        require(block.timestamp >= endTime,"You cannot update outcome before ending of market");
        outcome = _outcome;
        setClaimWinnigs = true;
        if(_outcome){
        winningAmount = address(this).balance / totalYesbets;
        }else{
        winningAmount = address(this).balance / totalNobets;
        }
        
    }

    function claimWinnigs() public {
        require(setClaimWinnigs,"Outcome is not determind till now");
        require(predictions[msg.sender] == outcome,"You have bet for incorrect prediction");
        if (userWinnings[msg.sender] == 0) {
            userWinnings[msg.sender] = winningAmount;
        } else {
            revert("You have already claimed your winnings");
        }

        payable(msg.sender).transfer(winningAmount);
    }
}