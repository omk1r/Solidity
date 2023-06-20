//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract Auction{
    address private manager;
    uint256 private highestBid;
    address private highestBidder;
    uint256 private endTime;
    address public winner;

    mapping(address => uint256) private bids;

    constructor() {
        manager = msg.sender;
        endTime = block.timestamp + 1 days;
    }

    function bid() public payable {
        require(msg.value > 0,"bid cannot be zero");
        require(block.timestamp <= endTime,"Auction has ended");
        bids[msg.sender] += msg.value;
        if(msg.value > highestBid){
            highestBid = msg.value;
            highestBidder = msg.sender;
        }
    }

    function auctionWinner() public returns(address){
        require(msg.sender == manager,"only owner can call winner");
        require(block.timestamp >= endTime,"Cannot choose winner before auction ending");
        return winner = highestBidder;
    }

    function withdraw() public {
        require(block.timestamp >= endTime,"Cannot choose winner before auction ending");
        require(msg.sender != highestBidder,"You cannot withdraw as you are the winner");
        uint256 amount = bids[msg.sender];
        bids[msg.sender] = 0;
       payable(msg.sender).transfer(amount);

    }
}