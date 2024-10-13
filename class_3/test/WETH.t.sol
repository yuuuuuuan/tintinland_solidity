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
        // 设置 user1 为测试调用方
        vm.startPrank(user1);

        // user1 向 WETH 合约发送 1 ETH
        weth.deposit{value: 1 ether}();

        // 检查 user1 的 WETH 余额是否为 1 WETH
        assertEq(weth.balanceOf(user1), 1 ether);

        // 检查合约的总供应量是否增加了 1 WETH
        assertEq(weth.totalSupply(), 1 ether);

        vm.stopPrank();
    }

    function testWithdraw() public {
        // 设置 user1 为测试调用方
        vm.startPrank(user1);

        // user1 存入 1 ETH
        weth.deposit{value: 1 ether}();
        assertEq(weth.balanceOf(user1), 1 ether);

        // user1 提取 0.5 ETH
        weth.withdraw(0.5 ether);

        // 检查 user1 的 WETH 余额是否减少到 0.5 WETH
        assertEq(weth.balanceOf(user1), 0.5 ether);

        // 检查合约的总供应量是否减少
        assertEq(weth.totalSupply(), 0.5 ether);

        vm.stopPrank();
    }

    function testTransfer() public {
        // 设置 user1 和 user2 为测试调用方
        vm.startPrank(user1);

        // user1 存入 1 ETH
        weth.deposit{value: 1 ether}();

        // user1 转账 0.5 WETH 给 user2
        weth.transfer(user2, 0.5 ether);

        // 检查 user1 和 user2 的 WETH 余额
        assertEq(weth.balanceOf(user1), 0.5 ether);
        assertEq(weth.balanceOf(user2), 0.5 ether);

        vm.stopPrank();
    }
}

