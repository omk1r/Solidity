//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;


contract Timelock{
    mapping(address => uint256) public balance;
    mapping(address => uint256) public _timeStamp;

    function deposit() public payable {
        balance[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public payable {
        require(balance[msg.sender] >= amount,"Insufficient balance");
        require(block.timestamp >= _timeStamp[msg.sender],"Account Timelock");
        (bool success,) = msg.sender.call{value:amount}("");
        require(success,"Transaction failed");
        _timeStamp[msg.sender] = block.timestamp + 1 days ;
        
    }

}