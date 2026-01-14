//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract marketplaceToken is ERC20 {
    uint256 public constant rate = 100000;

    constructor() ERC20("NFTToken","NT") {      
    }

    function buyNT() public payable{
        uint eth= msg.value;
        require(eth>0, "ether sent cannot be zero");
        uint256 tokenAmt = eth * rate;
        _mint(msg.sender,tokenAmt);

    }

        function checkBalance(address account) public view returns(uint){
            return balanceOf(account);
        }

}