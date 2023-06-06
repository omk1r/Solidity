//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";

contract check{
 using Address for address;

 function checkIfContract(address account) public view returns(bool) {
    return account.isContract();
 }
}