//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Swap{
    IERC20 public token1;
    IERC20 public token2;

    function swapToken(address _token1,address _token2,uint256 amount) public {
        token1 = IERC20(_token1);
        token2 = IERC20(_token2);
        require(token1.transferFrom(msg.sender,address(this),amount));
        require(token2.transfer(msg.sender,amount));
    }

    function getBalance(address _token) public view returns(uint256){
        IERC20 token = IERC20(_token);
        return token.balanceOf(address(this));
    }
}