// contracts/MyToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    uint256 public  tokenPrice = 0.00005 ether;

    constructor(address new_admin, uint256 initialSupply) ERC20("MyToken", "MT") {
        _mint(msg.sender, initialSupply); 
        transferOwnership(new_admin);
        _approve(owner(),address(this), initialSupply);
    }

    function buyTokens(uint256 amountTobuy) payable public {
        uint256 balance = address(this).balance;
        require(amountTobuy > 0, "You need to send some ether");

        uint256 totalAmount = tokenPrice * amountTobuy ;
        require(totalAmount <= balance,"Not enough tokens in the reserve");

        msg.sender.balance += amountTobuy;
        owner().balance -= totalAmount;
        transfer(owner(), amountTobuy);
    }

    function sellTokens(uint256 amount) public {
        require(amount > 0, "You need to sell at least some tokens");
        uint256 allowance = allowance(msg.sender, address(this));
        require(allowance >= amount, "Check the token allowance");
        transferFrom(msg.sender, address(this), amount);
        payable(msg.sender).transfer(amount);
    }

    function setTokenTrice(uint256 amount) public virtual onlyOwner{
        tokenPrice = amount;
    }

}