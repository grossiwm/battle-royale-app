// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract BattleRoyale {
    address public owner;
    mapping(address => uint256) public balances;
    uint256 public ownerBalance; 

    event Deposit(address indexed sender, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {

        require(msg.value > 0, "Value sent must be greater than 0");
        require(balances[msg.sender] == 0, "Address already participated");

        uint256 ownerFee = msg.value / 100;
        uint256 userAmount = msg.value - ownerFee;

        ownerBalance += ownerFee;

        balances[msg.sender] = userAmount;
    }

    function payWinnerAndOwner(address _winnerAddress) public {
        require(msg.sender == owner, "Only the owner can withdraw");

        uint256 ownerAmount = ownerBalance;
        ownerBalance = 0;

        (bool success, ) = payable(owner).call{value: ownerAmount}("");
        require(success, "Transfer to owner failed");

        uint256 winnerAmount = address(this).balance;

        (success, ) = payable(_winnerAddress).call{value: winnerAmount}("");
        require(success, "Transfer failed");
    }

    function getSenderBalance(address _address) public view returns (uint256) {
        return balances[_address];
    }
}
