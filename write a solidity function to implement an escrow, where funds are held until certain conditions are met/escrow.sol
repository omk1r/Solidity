//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow{
    address buyer;
    address seller;
    uint256 public buyerDeposited;
    uint256 sellerDeposited;
    bool buyerVote = false;
    bool sellerVote = false;

    constructor(address _buyer,address _seller) {
        buyer = _buyer;
        seller = _seller;
    }

    function deposit() public payable {
        require(msg.value >= 10 wei,"please send 10 wei to enter");
    
    if(msg.sender == buyer){
        buyerDeposited += msg.value;
    }
    if(msg.sender == seller){
        sellerDeposited += msg.value;
    }
    }

    function confirmVote() public {
    require(buyerDeposited > 0,"You haven't deposited");
    require(sellerDeposited > 0,"You haven't deposited");
    if(msg.sender == buyer){
        buyerVote = true;
    }
    if(msg.sender == seller){
        sellerVote = true;
    }
    }

    function cancelPayment() public {
     require(buyerDeposited > 0,"You haven't deposited");
     require(sellerDeposited > 0,"You haven't deposited");
     require(buyerVote,"buyer has not voted");
     require(sellerVote,"seller has not voted");
     payable(buyer).transfer(buyerDeposited);
     buyerDeposited = 0;
     payable(seller).transfer(sellerDeposited);
     sellerDeposited = 0;
    }

    function processPayment() public {
        require(msg.sender == buyer,"You are not the buyer");
        payable(seller).transfer(address(this).balance);
        buyerDeposited = 0;
        sellerDeposited = 0;
    }
}