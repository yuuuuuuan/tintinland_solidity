// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract AMMPool {
    using SafeERC20 for IERC20;

    IERC20 public token;
    IERC20 public weth;

    uint256 public tokenReserve;
    uint256 public wethReserve;
    uint256 public constant MINIMUM_LIQUIDITY = 10**3;

    event AddLiquidity(address indexed provider, uint256 wethAmount, uint256 tokenAmount);
    event RemoveLiquidity(address indexed provider, uint256 wethAmount, uint256 tokenAmount);
    event Swap(address indexed trader, uint256 wethIn, uint256 tokenOut, uint256 tokenIn, uint256 wethOut);

    constructor(IERC20 _weth, IERC20 _token) {
        weth = _weth;
        token = _token;
    }

    // 添加流动性
    function addLiquidity(uint256 wethAmount, uint256 tokenAmount) external {
        require(wethAmount > 0 && tokenAmount > 0, "Invalid amounts");
        
        weth.safeTransferFrom(msg.sender, address(this), wethAmount);
        token.safeTransferFrom(msg.sender, address(this), tokenAmount);

        wethReserve += wethAmount;
        tokenReserve += tokenAmount;

        emit AddLiquidity(msg.sender, wethAmount, tokenAmount);
    }

    // 移除流动性
    function removeLiquidity(uint256 wethAmount, uint256 tokenAmount) external {
        require(wethAmount <= wethReserve && tokenAmount <= tokenReserve, "Invalid amounts");
        
        weth.safeTransfer(msg.sender, wethAmount);
        token.safeTransfer(msg.sender, tokenAmount);

        wethReserve -= wethAmount;
        tokenReserve -= tokenAmount;

        emit RemoveLiquidity(msg.sender, wethAmount, tokenAmount);
    }

    // 代币兑换
    function swap(uint256 wethIn, uint256 tokenIn) external {
        require(wethIn > 0 || tokenIn > 0, "Invalid input");

        if (wethIn > 0) {
            // 用户提供 WETH，换取 ERC20 代币
            uint256 tokenOut = getAmountOut(wethIn, wethReserve, tokenReserve);
            require(tokenOut <= tokenReserve, "Insufficient liquidity");

            weth.safeTransferFrom(msg.sender, address(this), wethIn);
            token.safeTransfer(msg.sender, tokenOut);

            wethReserve += wethIn;
            tokenReserve -= tokenOut;

            emit Swap(msg.sender, wethIn, tokenOut, 0, 0);
        } else if (tokenIn > 0) {
            // 用户提供 ERC20 代币，换取 WETH
            uint256 wethOut = getAmountOut(tokenIn, tokenReserve, wethReserve);
            require(wethOut <= wethReserve, "Insufficient liquidity");

            token.safeTransferFrom(msg.sender, address(this), tokenIn);
            weth.safeTransfer(msg.sender, wethOut);

            tokenReserve += tokenIn;
            wethReserve -= wethOut;

            emit Swap(msg.sender, 0, 0, tokenIn, wethOut);
        }
    }

    // 基于常数乘积公式计算输出代币数量
    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public pure returns (uint256) {
        uint256 amountInWithFee = amountIn * 997;  // 假设手续费为 0.3%
        uint256 numerator = amountInWithFee * reserveOut;
        uint256 denominator = (reserveIn * 1000) + amountInWithFee;
        return numerator / denominator;
    }
}

