//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract DAO{

    struct Proposal {
        uint256 Id;
        address creator;
        uint256 amount;
        address sendTo;
        uint256 totalYesVotes;
        uint256 totalNoVotes;
        uint256 endTime;
    }

    uint256 public proposalCount;

    mapping(address => bool) public members;
    mapping(uint256 => Proposal) public proposals;
    mapping(address => bool) public voted;

    event ProposalCreated(uint256 Id,uint256 amount,address sendTo);
    event VotedProposal(uint256 ProposalId,bool vote);

    function becomeMember() public payable {
        require(msg.value >= 10 wei,"You have to send at least 10 wei");
        require(!members[msg.sender],"You are already a member");
        members[msg.sender] = true;
    }

    function createProposal(uint256 _amount,address _sendTo) public payable {
        require(members[msg.sender] == true,"Only members can create a propsal");
        require(msg.value >= 10 wei,"You need to send 10 wei to create a proposal");
        uint256 proposalId = proposalCount + 1;
        Proposal storage proposal = proposals[proposalId];
        proposal.Id = proposalId;
        proposal.creator = msg.sender;
        proposal.amount = _amount;
        proposal.sendTo = _sendTo;
        proposal.endTime = block.timestamp + 2 minutes;
        proposalCount++;
        emit ProposalCreated(proposalId,_amount,_sendTo);
    }

    function voteOnPropsal(uint256 _proposalId,bool _vote) public {
        require(members[msg.sender] == true,"You are not the member");
        require(proposals[_proposalId].endTime >= block.timestamp,"The timeline to vote is not ended yet");
        require(!voted[msg.sender],"You have already voted");
        if(_vote){
            proposals[_proposalId].totalYesVotes += 1;
        }else{
            proposals[_proposalId].totalNoVotes += 1;
        }
        voted[msg.sender] = true;
        emit VotedProposal(_proposalId,_vote);
    }

    function fulfilPrposal(uint256 _proposalId) public {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.creator == msg.sender,"Only creator of propsal deliver the propsal");
        require(proposal.endTime <= block.timestamp,"The timeline to vote is not ended yet");
        require(proposal.totalYesVotes > proposal.totalNoVotes,"More users have voted to dismiss the proposal");
        require(proposal.amount <= address(this).balance,"Contract does not have enough balance");
        address receiver = proposal.sendTo;
        payable(receiver).transfer(proposal.amount);
    }
}