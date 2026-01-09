// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.5.0
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OnChainToken is ERC20 {
    
    address payable owner;
    uint public constant TOKENS_PER_ETH = 100000;
    
    constructor() ERC20("OnChainToken", "OCT") 
    {
        owner = payable (msg.sender);
    }

    function mint() public payable {
        require(msg.value>0,"Eth amount cannot be zero");
        _mint(msg.sender, (msg.value * TOKENS_PER_ETH * (10**decimals()))/1 ether);
        (bool success,) = owner.call{value: msg.value}("");
        require(success);
    }
    

}