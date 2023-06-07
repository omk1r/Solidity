//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; 

contract Tokenbalance{

    function checkBalance(address tokenAddress,address _addr) public view returns(uint256) {
        IERC20 token = IERC20(tokenAddress);
        uint256 balance = token.balanceOf(_addr);
        return balance;
    }

}