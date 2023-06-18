//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CrowdFund{
    struct Campaign{
        address creator;
        uint32 goal;
        uint32 pledged;
        uint32 startAt;
        uint32 endAt;
        bool claimed;
    }

    IERC20 public immutable token;
    uint32 count;
    mapping(uint32 => Campaign) public campaigns;
    mapping(uint32 => mapping(address => uint32)) public pledgedAmount;


    constructor(address _token) {
        token = IERC20(_token);
    }

    function Launch(uint32 _goal,uint32 _startAt,uint32 _endAt) public {
        require(_startAt >= block.timestamp,"already started");
        require(_endAt >= _startAt,"you cannot end before starting");
        count += 1;
        campaigns[count] = Campaign({
            creator:msg.sender,
            goal:_goal,
            pledged:0,
            startAt:_startAt,
            endAt:_endAt,
            claimed:false
        });
    }
    
    function cancel(uint32 _id) public {
        require(block.timestamp <= campaigns[_id].startAt,"Already started");
        require(msg.sender == campaigns[_id].creator,"You are not the creator");
        delete campaigns[_id];
    }

    function pledge(uint32 _id,uint32 amount) public {
        require(block.timestamp <= campaigns[_id].endAt,"campaign already ended");
        campaigns[_id].pledged += amount;
        pledgedAmount[_id][msg.sender] += amount;

        token.transferFrom(msg.sender,address(this),amount);
    }

    function unPledge(uint32 _id,uint32 amount) public {
        require(amount <= pledgedAmount[_id][msg.sender],"not pledged this much");
        require(block.timestamp <= campaigns[_id].endAt,"campaign is already ended");
        campaigns[_id].pledged -= amount;
        pledgedAmount[_id][msg.sender] -= amount;
        token.transfer(msg.sender,amount);
    }

    function claim(uint32 _id) public {
        require(msg.sender == campaigns[_id].creator,"You are not the creator");
        require(block.timestamp >= campaigns[_id].endAt,"Campaign has not ended");
        require(campaigns[_id].goal <= campaigns[_id].pledged,"Goal has not been achieved");

        uint32 bal = campaigns[_id].pledged;
        token.transfer(msg.sender,bal);
    }

    function refund(uint32 _id) public{
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp >= campaign.endAt,"campaign has not been ended");
        require(campaign.goal <= campaign.pledged,"Goal has been achieved");

        uint32 amount = pledgedAmount[_id][msg.sender];
        token.transfer(msg.sender,amount); 
    }

}