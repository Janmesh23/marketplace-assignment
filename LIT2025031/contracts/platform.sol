// SPDX-License-Identifier: MIT


pragma solidity ^0.8.27;
import  "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract platform is ERC20{
    uint256 constant cons=100000;
    address  payable public _owner;
    constructor()  payable ERC20("tokenval","tval"){
        
      
      _owner=payable(msg.sender);
    }
   
   
function generatetoken() public payable {
    require(msg.value>0,"You do not have enough ETH to continue");
    
   uint256 _generatedval=msg.value*cons;
    
    _mint(msg.sender,_generatedval);

}

function checkbalance(address __owner) public view returns (uint256) {
 
  return balanceOf(__owner);
}
    
}