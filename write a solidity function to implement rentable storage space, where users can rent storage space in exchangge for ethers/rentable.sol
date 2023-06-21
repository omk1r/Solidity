//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract Rentable{
    struct Storage{
        uint256 rentedUntil;
        address renter;
    }
    uint256 public pricePerHour = 1 wei ;

    mapping(uint256 => Storage) public rents;

    function rent(uint256 _Id,uint256 _rentalHours) public payable {
        require(rents[_Id].renter == address(0),"Storage is rented ");
        require(msg.value == pricePerHour * _rentalHours,"please pay for storage until _endTime");
        if(block.timestamp > rents[_Id].rentedUntil){
            delete rents[_Id];
            rents[_Id].renter = msg.sender;
            rents[_Id].rentedUntil = block.timestamp + (_rentalHours * 1 hours);
        }
    }
}