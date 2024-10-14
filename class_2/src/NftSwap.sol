// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTSwap {
    struct Order {
        uint256 price;       
        address owner;       
    }

    mapping(address => mapping(uint256 => Order)) public orders;

    event OrderListed(address indexed nftContract, uint256 indexed tokenId, address indexed seller, uint256 price);
    event OrderRevoked(address indexed nftContract, uint256 indexed tokenId, address indexed seller);
    event OrderUpdated(address indexed nftContract, uint256 indexed tokenId, address indexed seller, uint256 newPrice);
    event NFTPurchased(address indexed nftContract, uint256 indexed tokenId, address indexed buyer, uint256 price);

    function listNFT(address _nftContract, uint256 _tokenId, uint256 _price) external {
        require(_price > 0, "Price must be greater than zero");
        IERC721 nftContract = IERC721(_nftContract);

        require(nftContract.ownerOf(_tokenId) == msg.sender, "You are not the owner of this NFT");
        require(nftContract.getApproved(_tokenId) == address(this), "Contract not approved to transfer this NFT");

        orders[_nftContract][_tokenId] = Order({
            price: _price,
            owner: msg.sender
        });

        emit OrderListed(_nftContract, _tokenId, msg.sender, _price);
    }

    function revokeOrder(address _nftContract, uint256 _tokenId) external {
        Order memory order = orders[_nftContract][_tokenId];

        require(order.owner == msg.sender, "You are not the owner of this order");

        delete orders[_nftContract][_tokenId];

        emit OrderRevoked(_nftContract, _tokenId, msg.sender);
    }

    function updateOrder(address _nftContract, uint256 _tokenId, uint256 _newPrice) external {
        require(_newPrice > 0, "Price must be greater than zero");
        Order storage order = orders[_nftContract][_tokenId];

        require(order.owner == msg.sender, "You are not the owner of this order");

        order.price = _newPrice;

        emit OrderUpdated(_nftContract, _tokenId, msg.sender, _newPrice);
    }

    function purchaseNFT(address _nftContract, uint256 _tokenId) external payable {
        Order memory order = orders[_nftContract][_tokenId];
        require(order.price > 0, "Order does not exist");
        require(msg.value == order.price, "Incorrect payment amount");

        IERC721 nftContract = IERC721(_nftContract);
        require(nftContract.ownerOf(_tokenId) == order.owner, "Invalid owner");
        require(
            nftContract.getApproved(_tokenId) == address(this) || 
            nftContract.isApprovedForAll(order.owner, address(this)), 
            "Not approved to transfer NFT"
        );

        // Transfer the NFT
        nftContract.safeTransferFrom(order.owner, msg.sender, _tokenId);

        // Transfer Ether to the seller
        (bool success, ) = order.owner.call{value: msg.value}("");
        require(success, "Transfer to seller failed");

        // Refund excess payment if applicable
        if (msg.value > order.price) {
            (bool refundSuccess, ) = msg.sender.call{value: msg.value - order.price}("");
            require(refundSuccess, "Refund failed");
        }

        // Delete the order
        delete orders[_nftContract][_tokenId];

        emit NFTPurchased(_nftContract, _tokenId, msg.sender, order.price);
    }

}

