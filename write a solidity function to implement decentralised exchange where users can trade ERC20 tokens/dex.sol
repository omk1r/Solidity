//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract dex{
    mapping(address => mapping(address => uint256)) public balances;
    uint256 tokenPrice = 100;
   mapping(address => mapping(address => mapping(address => uint256))) private _allowances;

    function allowance(address token, address owner, address spender) external view returns (uint256) {
        return _allowances[token][owner][spender];
    }

    function approve(address token, address spender, uint256 amount) external returns (bool) {
        _allowances[token][msg.sender][spender] = amount;
        return true;
    }

    function buyToken(address _token,uint256 amount) public payable {
       IERC20 token = IERC20(_token);
       require(token.balanceOf(address(this)) >= amount,"Not enough balance in exchange");

       uint256 rate = msg.value/tokenPrice;
       require(rate >= amount,"Send more eth to purchase tokens");
      
      token.transfer(msg.sender,amount);
      
    }

    function sellToken(address _token,uint256 amount) public payable{
        IERC20 token = IERC20(_token);
        require(token.balanceOf(msg.sender) >= amount,"You don't have enough balance");

        uint256 eth = amount * tokenPrice;
        require(address(this).balance >= eth,"Not enough balance in exchange for tokens");
        require(_allowances[_token][msg.sender][address(this)] >= amount,"Not enough allowance");
        token.transferFrom(msg.sender,address(this),amount);
        payable(msg.sender).transfer(eth);
    }

    function depositToken(address _token,uint256 amount) public {
        IERC20 token = IERC20(_token);
        require(token.balanceOf(msg.sender) >= amount,"You don't have enough balance");
        require(_allowances[_token][msg.sender][address(this)] >= amount,"Not enough allowance");
        token.transferFrom(msg.sender,address(this),amount);
        balances[msg.sender][_token] += amount;
    }

    function withdrawToken(address _token,uint256 amount) public {
        IERC20 token =IERC20(_token);
        require(balances[msg.sender][_token] >= amount,"You are withdrwing more than you deposited");
        token.transfer(msg.sender,amount);
        balances[msg.sender][_token] -= amount;
    }

    function depositEth() public payable {
        require(msg.value >= 0,"you need to deposit some eth");
        balances[msg.sender][address(0)] += msg.value;
    }

    function withdrawEth(uint256 amount) public {
        require(balances[msg.sender][address(0)] >= amount,"You haven't deposited much eth");
        payable(msg.sender).transfer(amount);
        balances[msg.sender][address(0)] -= amount;
    }
}