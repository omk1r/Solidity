//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Staking is ERC20 {
    constructor() ERC20("Testtoken","TEST"){
        _mint(msg.sender,1000000);
    }

    mapping(address => uint256) public staked;
    mapping(address => uint256) public stakedTs;

    function stake(uint32 amount) external {
        require(amount > 0 , "amount should be greater than zero");
        require(balanceOf(msg.sender) >= amount,"You don't have enough balance");
        staked[msg.sender] += amount;
        stakedTs[msg.sender] = block.timestamp;
        _transfer(msg.sender,address(this),amount);
    }

    function unstake(uint32 amount) external {
        require(amount > 0 , "amount should be greater than zero");
        require(staked[msg.sender] > 0,"you haven't staked any token");
        claim();
        staked[msg.sender] -= amount;
        _transfer(address(this),msg.sender,amount);
    }

    function claim() public {
        require(staked[msg.sender] > 0,"you haven't staked any token");
        uint256 secondsStaked = block.timestamp - stakedTs[msg.sender] ;
        uint256 reward = staked[msg.sender] * secondsStaked / 3.154e7;
        _mint(msg.sender,reward);
        stakedTs[msg.sender] = 0;
    }
}