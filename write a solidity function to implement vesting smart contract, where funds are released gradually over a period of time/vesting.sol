//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vesting{
    struct Vested{
        IERC20 token;
        uint256 totalTokens;
        uint256 time;
        uint256 unreleasedToken;
    }

    mapping(address => Vested) public vestedTokens;

    function vestTokens(address _token,uint256 _amount) public {
        IERC20 token1 = IERC20(_token);
        require(token1.transferFrom(msg.sender,address(this),_amount),"Please approve the contract to vest tokens");
        Vested storage vest = vestedTokens[msg.sender];
        vest.token = token1;
        vest.totalTokens = _amount;
        vest.time = block.timestamp + 1 minutes;
        vest.unreleasedToken = _amount;
    }

    function releaseToken() public {
        Vested storage vest = vestedTokens[msg.sender];
        require(vest.totalTokens > 0,"You don't have any tokens vested");
        require(vest.time <= block.timestamp,"Your vesting period is not over yet");
        uint256 releasableTokens = vest.unreleasedToken * 1 / 100;
        vest.unreleasedToken -= releasableTokens;
        vest.time = block.timestamp + 1 days;
        IERC20 token = vest.token;
        token.transfer(msg.sender,releasableTokens);
        
    }
}