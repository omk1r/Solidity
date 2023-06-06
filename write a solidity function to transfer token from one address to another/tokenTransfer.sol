//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenTransfer {
    address private _tokenAddress;
    


    constructor(address tokenAddress) {
        _tokenAddress = tokenAddress;
    }
    mapping(address => uint) public balanceOf;

    function sendTokens(address recipient, uint256 amount) external {
        require(amount > 0,"Amount must be greater than zero");
        ERC20 token = ERC20(_tokenAddress);
        uint256 balance = token.balanceOf(msg.sender);
        require(balance >= amount,"Insufficient balance");
        bool success = token.transfer(recipient, amount);
        require(success,"Toekn transfer failed");
        
    }
}