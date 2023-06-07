//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;


contract WithdrawTokens{
    mapping(address => uint) public balances;
    bool reEntrance = true;

    function deposit() public payable returns(bool){
        require(msg.value > 0,"Amount should be greater than zero ");
        balances[msg.sender] += msg.value;
        return true;
    }

    function withdraw(uint256 amount) public payable returns(bool){
        require(reEntrance = true,"no reEntrance");
        reEntrance = false;
        (bool success,) = msg.sender.call{value: amount}("");
        require(success,"Transaction failed");
        balances[msg.sender] -= amount;
        reEntrance = true;
        return true;
    }

    receive() external payable{}
    fallback() external payable{}
}

