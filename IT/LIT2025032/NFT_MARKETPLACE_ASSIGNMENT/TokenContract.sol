// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Token {

    mapping(address => uint256) public balanceOfUser;

    uint256 constant tokensPerETH = 100000;

    function MINTtokens() public payable{
        require (msg.value>0,"ETH required to MINT Tokens");

        uint256 tokensToMint = (msg.value * tokensPerETH)/1 ether;
        balanceOfUser[msg.sender] +=tokensToMint;
    }

    function showBalance() public view returns (uint256){
        return balanceOfUser[msg.sender];
    }

    mapping(address => mapping(address => uint256)) public allowance;

    function approve(address marketPlace, uint256 amount) public returns (bool){
        allowance[msg.sender][marketPlace] = amount;
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool){
        require(balanceOfUser[from]>=amount, "Insufficient Balance");
        require(allowance[from][msg.sender] >= amount, "Not approved");

        allowance[from][msg.sender] -=amount;
        balanceOfUser[from] -=amount;
        balanceOfUser[to] +=amount;

        return true;
        
    }

}