//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract Identity{
    address manager;

    struct Attributes{
        string Name;
        uint32 Age;
    }

    constructor(){
        manager = msg.sender;
    }

    mapping(address => Attributes) internal identities;
    mapping(address => bool) internal isRegistered;

    function setIdentity(string memory _name,uint32 _age) public {
        require(!isRegistered[msg.sender],"Already reggistered");
        Attributes storage identity = identities[msg.sender];
        identity.Name = _name;
        identity.Age = _age;
        isRegistered[msg.sender] = true;
    }

    function checkIdentity(address _addr) public view returns(string memory,uint32) {
        require(isRegistered[msg.sender] && msg.sender == _addr || msg.sender == manager,"You are not registered or you are not the owner of _addr");
        Attributes storage identity = identities[_addr];
        return(identity.Name,identity.Age);
    }
}