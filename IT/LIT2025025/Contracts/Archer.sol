// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

contract Archer  {

    address private Owner;
    string public TokenName;
    string public TokenSymbol;

    constructor() {
       TokenName = "Archer"; 
       TokenSymbol = "ARCH"; 
       Owner =msg.sender;
    }

    address[] public Archers;
    mapping(address user =>uint256 amount) public AmountofARCH;

    function mintArcher() public payable {

        require(msg.value >= 10000000000000, "Minimum 0.00001 ETH required to Mint");
        Archers.push(msg.sender);
        AmountofARCH[msg.sender] += msg.value/10000000000000;
    }

    function withdrawETH() public onlyOwner{

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
   }

    modifier onlyOwner() {
        require(msg.sender == Owner, "Must be owner");
        _;
    }
}