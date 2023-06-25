//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract gasLessTransfer{
    struct Transfer{
        IERC20 token;
        address sender;
        address receiver;
        uint256 amount;
        uint256 fee;
        bool executed;
    }

    mapping(uint256 => Transfer) public transfers;

    function requestTransfer(IERC20 _token,address _receiver,uint256 _amount,uint256 _fee) external {
        require(_fee > 0 ,"Amount and fee should be greater than zero");
        uint256 transferId;
        transfers[transferId + 1] = Transfer(_token,msg.sender,_receiver,_amount,_fee,false);
    }

    function executeTransaction(uint256 _transferId) external {
        Transfer storage transfer = transfers[_transferId];
        require(!transfer.executed,"Transaction already executed");
        transfer.token.transferFrom(transfer.sender,transfer.receiver,transfer.amount);
        transfer.token.transferFrom(transfer.sender,msg.sender,transfer.fee);
        transfer.executed = true;
    }
}