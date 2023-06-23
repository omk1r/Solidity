//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract Insurance{
    address public owner;
    mapping(address => uint256) internal policyholders;

    constructor(){
        owner = msg.sender;
    }

    function buyPolicy() external payable{
        require(msg.value > 0,"You cannot but policy with 0 ether");
        policyholders[msg.sender] += msg.value;
    }

    function claimPolicy() public {
        require(policyholders[msg.sender] > 0,"You haven't purchased policy");
        uint256 requiredAmount = 100 ether;
        uint256 balance = address(msg.sender).balance;
        if(balance < requiredAmount){
        uint256 amount = policyholders[msg.sender];
        policyholders[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
        }
    }

    function withdrawFunds(uint256 amount) public {
        require(msg.sender == owner,"Only owner can withdraw funds");
        require(amount <= address(this).balance,"Not enough balance");
        payable(owner).transfer(amount);
    }
}