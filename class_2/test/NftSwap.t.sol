// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../src/NFTSwap.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MockNFT is ERC721 {
    constructor() ERC721("MockNFT", "MNFT") {}

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }
}

contract NFTSwapTest is Test {
    NFTSwap public nftSwap;
    MockNFT public nft;
    address public seller = address(1);
    address public buyer = address(2);

    function setUp() public {
        nftSwap = new NFTSwap();
        nft = new MockNFT();

        // mint NFT to seller
        nft.mint(seller, 1);

        // Give seller and buyer some Ether
        vm.deal(seller, 10 ether);
        vm.deal(buyer, 10 ether);
    }

    function testListNFT() public {
        vm.startPrank(seller);
        nft.approve(address(nftSwap), 1);
        nftSwap.listNFT(address(nft), 1, 1 ether);
        (uint256 price, address owner) = nftSwap.orders(address(nft), 1);
        assertEq(price, 1 ether);
        assertEq(owner, seller);
        vm.stopPrank();
    }
    function testPurchaseNFT() public {
        // 卖家挂单 NFT
        vm.startPrank(seller);
        uint256 tokenId = 1;           // 定义 tokenId
        uint256 price = 1 ether;       // 定义价格

        // 授权 NFTSwap 合约可以转移卖家的 NFT
        nft.approve(address(nftSwap), 1);
        // 卖家挂单
        nftSwap.listNFT(address(nft), tokenId, price);
        vm.stopPrank();

        // 买家购买 NFT
        vm.startPrank(buyer);
        vm.deal(buyer, price); // 确保买家有足够的资金

        // 买家支付价格购买 NFT
        nftSwap.purchaseNFT{value: price}(address(nft), tokenId);

        // 检查买家是否成为 NFT 的新拥有者
        assertEq(nft.ownerOf(tokenId), buyer);

        // 检查订单是否已被删除
        (uint256 orderPrice, address orderOwner) = nftSwap.orders(address(nft), tokenId);
        //(address orderOwner, uint orderPrice) = nftSwap.orders(address(nft), tokenId);
        assertEq(orderOwner, address(0));  // 订单持有者应该被重置为 0 地址
        assertEq(orderPrice, 0);           // 订单价格应该被重置为 0

        vm.stopPrank();
    }
 /*   
    function testPurchaseNFT() public {
        // Seller lists NFT
        vm.startPrank(seller);
        nft.approve(address(nftSwap), 1);
        nftSwap.listNFT(address(nft), 1, 1 ether);
        vm.stopPrank();

        // Buyer purchases NFT
        vm.startPrank(buyer);
        nftSwap.purchaseNFT{value: 1 ether}(address(nft), 1);
        assertEq(nft.ownerOf(1), buyer);
        vm.stopPrank();
    }
    */
    function testRevokeOrder() public {
        vm.startPrank(seller);
        nft.approve(address(nftSwap), 1);
        nftSwap.listNFT(address(nft), 1, 1 ether);
        nftSwap.revokeOrder(address(nft), 1);
        (uint256 price, address owner) = nftSwap.orders(address(nft), 1);
        assertEq(price, 0);
        assertEq(owner, address(0));
        vm.stopPrank();
    }

    function testUpdateOrder() public {
        vm.startPrank(seller);
        nft.approve(address(nftSwap), 1);
        nftSwap.listNFT(address(nft), 1, 1 ether);
        nftSwap.updateOrder(address(nft), 1, 2 ether);
        (uint256 price, address owner) = nftSwap.orders(address(nft), 1);
        assertEq(price, 2 ether);
        assertEq(owner, seller);
        vm.stopPrank();
    }
}

