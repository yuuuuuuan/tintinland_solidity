// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../src/NftSwap.sol";
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

        vm.startPrank(seller);
        uint256 tokenId = 1;
        uint256 price = 1 ether;
        //uint256 buyer_money = 10 ether;

        nft.approve(address(nftSwap), 1);

        nftSwap.listNFT(address(nft), tokenId, price);
        vm.stopPrank();

        vm.startPrank(buyer);
        //vm.deal(buyer, buyer_money);

        nftSwap.purchaseNFT{value: price}(address(nft), tokenId);

        assertEq(nft.ownerOf(tokenId), buyer);

        (uint256 orderPrice, address orderOwner) = nftSwap.orders(address(nft), tokenId);
        //(address orderOwner, uint orderPrice) = nftSwap.orders(address(nft), tokenId);
        assertEq(orderOwner, address(0));  
        assertEq(orderPrice, 0);           

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

