// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract creation {

string public token_name="TOKIE";
string public symbol = "OM";
uint8 public decimals = 18;

mapping ( address => uint256) public balanceof;

event Transfer(address indexed from, address indexed to, uint256 amount);
event TokensPurchased(address indexed buyer, uint256 ethAmount, uint256 tokenAmount);

function conversion() public payable {



     uint256 rate = 100000 * (10 ** 18);
     
    require(msg.value>0,"YOU ARE POOR");
    uint256 tokie = (msg.value* rate) / (1 ether);
    balanceof[msg.sender]= balanceof[msg.sender] + tokie;
     emit TokensPurchased(msg.sender,msg.value, tokie);

}



function transfer(address to, uint256 amount) public returns(bool) {

require(balanceof[msg.sender] >= amount, "Insufficient tokens");
balanceof[msg.sender] -= amount;
balanceof[to] += amount;
emit Transfer(msg.sender, to, amount);
return true;

}

function check_balance() public view returns(uint256){

return balanceof[msg.sender];

} }