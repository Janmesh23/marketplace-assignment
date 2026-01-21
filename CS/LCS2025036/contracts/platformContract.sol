// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract platformContract is ERC20{
    constructor() ERC20("Shaan","SH"){}
    function mintSH() public payable{
        require(msg.value > 0, "Send ETH to mint tokens");
        uint token = msg.value*100000;
        _mint(msg.sender,token);
    }
    function checkBalance(address user) public view returns (uint){
        return balanceOf(user);
    }
}  