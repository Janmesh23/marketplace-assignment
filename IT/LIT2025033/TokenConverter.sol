// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract MyTokens is ERC20{

    uint256 private ETH = 100000;
    string public TokenValue = "1 ETH = 100000 Tokens";
    // mapping(address => uint256) private Token; 
    mapping(address => uint256) private Balance;
    address public owner;

    constructor(uint256 initialSupply) ERC20("MyToken", "MTK"){ 
    
        owner = msg.sender;
        _mint(msg.sender, initialSupply);
    }
    modifier onlyOwner{
        require(msg.sender == owner, "Not contract owner");
        _;
    }
    function deposit() external payable{
        Balance[msg.sender]+=msg.value / 1 ether;
    }
    function getToken(uint256 _amount) payable external{
        require(Balance[msg.sender]>=_amount,"Insufficient balance");
        _mint(msg.sender, _amount*ETH);
        Balance[msg.sender]-=_amount;
        (bool success, ) = owner.call{value: _amount * 1 ether}("");
        require(success,"Transfer failed");
    }
    
    function getMyTokens() public view returns(uint256){
        return balanceOf(msg.sender);
    }
    function Withdraw(uint256 amount) external {
        require(Balance[msg.sender]>=amount,"Insufficient balance");
        Balance[msg.sender]-=amount;
        (bool success, ) = msg.sender.call{value: amount * 1 ether}("");
        require(success,"Transfer failed");
    }
    function getMyBalance() public view returns(uint256){
        return Balance[msg.sender];
    }


}