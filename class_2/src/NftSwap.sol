// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTSwap {
    // 定义订单结构体
    struct Order {
        uint256 price;       // 挂单价格
        address owner;       // 卖家地址
    }

    // 存储每个 NFT 合约地址 -> tokenId -> 订单信息
    mapping(address => mapping(uint256 => Order)) public orders;

    // 事件定义
    event OrderListed(address indexed nftContract, uint256 indexed tokenId, address indexed seller, uint256 price);
    event OrderRevoked(address indexed nftContract, uint256 indexed tokenId, address indexed seller);
    event OrderUpdated(address indexed nftContract, uint256 indexed tokenId, address indexed seller, uint256 newPrice);
    event NFTPurchased(address indexed nftContract, uint256 indexed tokenId, address indexed buyer, uint256 price);

    // 卖家挂单
    function listNFT(address _nftContract, uint256 _tokenId, uint256 _price) external {
        require(_price > 0, "Price must be greater than zero");
        IERC721 nftContract = IERC721(_nftContract);

        // 检查调用者是否是该 tokenId 的拥有者，且合约有授权转移权限
        require(nftContract.ownerOf(_tokenId) == msg.sender, "You are not the owner of this NFT");
        require(nftContract.getApproved(_tokenId) == address(this), "Contract not approved to transfer this NFT");

        // 挂单
        orders[_nftContract][_tokenId] = Order({
            price: _price,
            owner: msg.sender
        });

        emit OrderListed(_nftContract, _tokenId, msg.sender, _price);
    }

    // 卖家撤单
    function revokeOrder(address _nftContract, uint256 _tokenId) external {
        Order memory order = orders[_nftContract][_tokenId];

        require(order.owner == msg.sender, "You are not the owner of this order");

        // 清空订单
        delete orders[_nftContract][_tokenId];

        emit OrderRevoked(_nftContract, _tokenId, msg.sender);
    }

    // 卖家修改挂单价格
    function updateOrder(address _nftContract, uint256 _tokenId, uint256 _newPrice) external {
        require(_newPrice > 0, "Price must be greater than zero");
        Order storage order = orders[_nftContract][_tokenId];

        require(order.owner == msg.sender, "You are not the owner of this order");

        // 更新价格
        order.price = _newPrice;

        emit OrderUpdated(_nftContract, _tokenId, msg.sender, _newPrice);
    }

    // 买家购买 NFT
    function purchaseNFT(address _nftContract, uint256 _tokenId) external payable {
        Order memory order = orders[_nftContract][_tokenId];
        require(order.price > 0, "Order does not exist");
        require(msg.value == order.price, "Incorrect payment amount");

        // 转移 NFT 到买家
        IERC721 nftContract = IERC721(_nftContract);
        nftContract.safeTransferFrom(order.owner, msg.sender, _tokenId);

        // 将资金转移给卖家
        payable(order.owner).transfer(msg.value);
	
	if (msg.value > order.price) {
	    payable(msg.sender).transfer(msg.value - order.price);
	}
        // 清空订单
        delete orders[_nftContract][_tokenId];

        emit NFTPurchased(_nftContract, _tokenId, msg.sender, order.price);
    }
}

