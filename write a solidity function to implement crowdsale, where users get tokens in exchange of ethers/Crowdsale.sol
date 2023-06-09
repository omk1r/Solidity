//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Crowdsale{
    address tokenaddress;
    uint256 tokenPrice;
    uint256 public tokensSold;


    constructor(address _tokenaddress,uint256 _tokenPrice) {
        tokenaddress = _tokenaddress;
        tokenPrice = _tokenPrice;
        tokensSold = 0;
    }

    function buyToken() public payable returns(uint256) {
        require(msg.value > 0,"Send some ethers");

        uint256 amount = msg.value/tokenPrice;
        require(amount > 0,"Send more ether");

        IERC20 token = IERC20(tokenaddress);
        require(token.balanceOf(address(this)) >= amount, "Insufficient tokens available for sale");
        token.transfer(msg.sender,amount);

        tokensSold += amount;
        return token.balanceOf(address(this));
    }
}
