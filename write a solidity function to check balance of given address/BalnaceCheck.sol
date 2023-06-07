//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;


contract balance{

    function checkBalance(address _addr) public view returns(uint256) {
        return _addr.balance;
    }

}