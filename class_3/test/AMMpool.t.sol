// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/AMMPool.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor() ERC20("Test Token", "TT") {
        _mint(msg.sender, 1_000_000 * 10**18); // mint 1,000,000 TT
    }
}

contract AMMPoolTest is Test {
    AMMPool public pool;
    Token public token;
    Token public weth;

    address public liquidityProvider = address(1);
    address public trader = address(2);

    function setUp() public {
        // 部署两个测试用的 ERC20 代币
        token = new Token(); // ERC20 Token
        weth = new Token();  // 模拟 WETH

        // 部署 AMM 流动性池
        pool = new AMMPool(IERC20(weth), IERC20(token));

        // 给测试地址 mint 一些初始代币
        token.transfer(liquidityProvider, 1000 * 10**18); // 给 liquidityProvider 1000 个 TT
        weth.transfer(liquidityProvider, 1000 * 10**18);  // 给 liquidityProvider 1000 个 WETH
        token.transfer(trader, 500 * 10**18);             // 给 trader 500 个 TT
        weth.transfer(trader, 500 * 10**18);              // 给 trader 500 个 WETH
    }

    // 测试添加流动性
    function testAddLiquidity() public {
        vm.startPrank(liquidityProvider);

        // 允许 AMM Pool 合约从 liquidityProvider 处转账
        token.approve(address(pool), 100 * 10**18);
        weth.approve(address(pool), 100 * 10**18);

        // 添加流动性
        pool.addLiquidity(100 * 10**18, 100 * 10**18);

        // 测试是否正确添加了流动性
        assertEq(pool.wethReserve(), 100 * 10**18);
        assertEq(pool.tokenReserve(), 100 * 10**18);

        vm.stopPrank();
    }

    // 测试移除流动性
    function testRemoveLiquidity() public {
        vm.startPrank(liquidityProvider);

        // 先添加流动性
        token.approve(address(pool), 100 * 10**18);
        weth.approve(address(pool), 100 * 10**18);
        pool.addLiquidity(100 * 10**18, 100 * 10**18);

        // 移除流动性
        pool.removeLiquidity(50 * 10**18, 50 * 10**18);

        // 测试是否正确移除了流动性
        assertEq(pool.wethReserve(), 50 * 10**18);
        assertEq(pool.tokenReserve(), 50 * 10**18);

        vm.stopPrank();
    }

    // 测试代币交换（WETH 换取 Token）
    function testSwapWETHForToken() public {
        vm.startPrank(liquidityProvider);

        // 先添加流动性
        token.approve(address(pool), 100 * 10**18);
        weth.approve(address(pool), 100 * 10**18);
        pool.addLiquidity(100 * 10**18, 100 * 10**18);

        vm.stopPrank();
        vm.startPrank(trader);

        // trader 允许 pool 转移 WETH
        weth.approve(address(pool), 10 * 10**18);

        // trader 使用 10 WETH 进行交换
        pool.swap(10 * 10**18, 0);

        // 测试 pool 中的储备是否更新
        assertEq(pool.wethReserve(), 110 * 10**18); // 增加了 10 WETH
        assert(pool.tokenReserve() < 100 * 10**18); // tokenReserve 减少，token 被换走

        vm.stopPrank();
    }

    // 测试代币交换（Token 换取 WETH）
    function testSwapTokenForWETH() public {
        vm.startPrank(liquidityProvider);

        // 先添加流动性
        token.approve(address(pool), 100 * 10**18);
        weth.approve(address(pool), 100 * 10**18);
        pool.addLiquidity(100 * 10**18, 100 * 10**18);

        vm.stopPrank();
        vm.startPrank(trader);

        // trader 允许 pool 转移 token
        token.approve(address(pool), 10 * 10**18);

        // trader 使用 10 Token 进行交换
        pool.swap(0, 10 * 10**18);

        // 测试 pool 中的储备是否更新
        assertEq(pool.tokenReserve(), 110 * 10**18); // 增加了 10 Token
        assert(pool.wethReserve() < 100 * 10**18);   // wethReserve 减少，weth 被换走

        vm.stopPrank();
    }
}
   

