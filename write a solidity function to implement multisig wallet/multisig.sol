//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract multisig{
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 required;
    struct Transaction{
        address to;
        uint256 amount;
        bool executed;
        uint numConfirmations;
    }
    event SubmitTransaction( address indexed owner,
        uint indexed txIndex,
        address indexed to,
        uint value
        );
        
    Transaction[] public transactions;
    mapping(uint256 => mapping(address => bool)) public approved;

    modifier onlyOwner() {
        require(isOwner[msg.sender],"Only owner can send trasaction");
        _;
    }

    constructor(address[] memory _owner,uint256 _required) {
        require(_owner.length > 0,"Add atleast one owner");
        require(_required > 0 && required <= _owner.length,"Put more than one confirmations required");
        for(uint i; i <= _owner.length ; i++){
            address owner = _owner[i];
            require(!isOwner[owner],"owner not unique");
            isOwner[owner] = true;
            owners.push(owner);
        }
        required =_required;
    }

    receive() external payable{}

    function submitTransaction(address _to,uint256 _amount) public onlyOwner {
        uint txIndex = transactions.length;
        transactions.push(Transaction({
            to : _to,
            amount : _amount,
            executed : false,
            numConfirmations: 0
        }));

        emit SubmitTransaction(msg.sender, txIndex, _to, _amount);
    }

    function approveTransaction(uint _txId) public onlyOwner {
        require(_txId <= transactions.length,"Valid id");
        require(!transactions[_txId].executed,"Trasaction already executed");
        require(!approved[_txId][msg.sender],"already approved");
        Transaction storage transaction = transactions[_txId];
        transaction.numConfirmations += 1;
        approved[_txId][msg.sender] = true;
    }


    function executeTransaction(
        uint _txId
    ) public onlyOwner {
         require(_txId <= transactions.length,"Valid id");
        require(!transactions[_txId].executed,"Trasaction already executed");
        Transaction storage transaction = transactions[_txId];

        require(
            transaction.numConfirmations >= required,
            "cannot execute tx"
        );

        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.amount}("");
        require(success, "tx failed");

    }

     function revokeTransaction(
        uint _txId
    ) public onlyOwner {
        Transaction storage transaction = transactions[_txId];

        require(approved[_txId][msg.sender], "tx not confirmed");

        transaction.numConfirmations -= 1;
        approved[_txId][msg.sender] = false;
    }

    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    function getTransactionCount() public view returns (uint) {
        return transactions.length;
    }

    function getTransaction(
        uint _txId
    )
        public
        view
        returns (
            address to,
            uint amount,
            bool executed,
            uint numConfirmations
        )
    {
        Transaction storage transaction = transactions[_txId];

        return (
            transaction.to,
            transaction.amount,
            transaction.executed,
            transaction.numConfirmations
        );
    }
   }
 