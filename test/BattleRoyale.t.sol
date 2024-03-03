// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BattleRoyale} from "../src/BattleRoyale.sol";

contract BattleRoyaleTest is Test {
    BattleRoyale public br;

    function setUp() public {

        br = new BattleRoyale();
    }

    function test_Receive() public {
        address senderAddress = vm.addr(1);

        vm.prank(senderAddress);
        vm.deal(senderAddress, 2 gwei);

        (bool success, ) = address(br).call{value: 1 gwei}("");
        require(success, "Failed to send Ether");

        uint256 ownerBalance = br.ownerBalance();

        assertEq(((1 gwei)/100), ownerBalance);
        assertEq(1 gwei - (1 gwei)/100, br.getSenderBalance(senderAddress));

        senderAddress = vm.addr(2);

        vm.prank(senderAddress);
        vm.deal(senderAddress, 2 gwei);
        
        (success, ) = address(br).call{value: 1 gwei}("");
        require(success, "Failed to send Ether");

        assertEq(address(br).balance, 2 gwei, "The balance should be equals 2 gwei");

        ownerBalance = br.ownerBalance();

        assertEq(2*((1 gwei)/100), ownerBalance);
        assertEq(1 gwei - (1 gwei)/100, br.getSenderBalance(senderAddress));

    }

}
