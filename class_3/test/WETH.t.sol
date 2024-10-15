// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/WETH.sol"; // 导入刚刚实现的 WETH 合约

contract WETHTest is Test {
    WETH private weth;

    // 定义参与者
    address user1 = address(0x123);
    address user2 = address(0x456);

    function setUp() public {
        // 部署 WETH 合约
        weth = new WETH();
    }

    function testDeposit() public {

        vm.deal(user1, 1 ether); 
        vm.prank(user1); 
        weth.deposit{value: 1 ether}();

        assertEq(weth.balanceOf(user1), 1 ether);

        assertEq(weth.totalSupply(), 1 ether);

        vm.stopPrank();
    }

function testWithdraw() public {
        // Arrange: Deposit ETH first
        uint256 depositAmount = 1 ether;
        vm.deal(user1, depositAmount);
        vm.prank(user1);
        weth.deposit{value: depositAmount}();

        // Act: Withdraw WETH
        uint256 withdrawAmount = depositAmount;
        vm.prank(user1);
        weth.withdraw(withdrawAmount);

        // Assert: Check balances after withdrawal
        assertEq(
            user1.balance,
            withdrawAmount,
            "User should hold the withdrawAmount ETH"
        );
        assertEq(
            address(weth).balance,
            0,
            "WETH contract should not hold any ETH"
        );
        assertEq(
            weth.balanceOf(address(weth)),
            0,
            "WETH contract should not hold any WETH"
        );
        assertEq(weth.balanceOf(user1), 0, "User should not hold any WETH");
    }

    function testTransfer() public {
        // 设置 user1 和 user2 为测试调用方
        vm.deal(user1, 1 ether); 
        vm.deal(user2, 1 ether); 
        
        // 让 user1 存入 1 ether 到 WETH
        vm.prank(user1);
        weth.deposit{value: 1 ether}();
        
        // 验证 user1 的 WETH 余额是否为 1 ether
        assertEq(weth.balanceOf(user1), 1 ether);

        // 让 user1 将 0.5 ether 转账给 user2
        vm.prank(user1);
        weth.transfer(user2, 0.5 ether);

        // 验证转账后两者的 WETH 余额
        assertEq(weth.balanceOf(user1), 0.5 ether);
        assertEq(weth.balanceOf(user2), 0.5 ether);

        vm.stopPrank();
    }

}

