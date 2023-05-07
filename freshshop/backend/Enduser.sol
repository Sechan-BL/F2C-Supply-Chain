// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Distributer.sol";
import "./Producer.sol";

contract EndUser {
    address public distributorAddress;
    address public producerAddress;

    constructor(address _distributorAddress, address _producerAddress) {
        distributorAddress = _distributorAddress;
        producerAddress = _producerAddress;
    }

    function buyProduct(uint256 _productId, uint256 _quantity) public payable {
        // Fetch product details from Producer contract
        (, , , , uint256 quantity, uint256 price, , , , , ) = Producer(producerAddress).getProductDetails(_productId);
        require(quantity >= _quantity, "Insufficient quantity available");

        // Calculate total price and transfer funds to distributor
        uint256 totalPrice = price * _quantity;
        require(msg.value >= totalPrice, "Insufficient funds sent");
        (bool sent, ) = distributorAddress.call{value: totalPrice}("");
        require(sent, "Payment failed");

        // Place order with the distributor
        Distributor(distributorAddress).placeOrder(_productId, _quantity);
    }

    function receiveOrder(uint256 _orderId) public {
        require(orders[_orderId].buyer == msg.sender, "Only the buyer can receive the order");
        require(orders[_orderId].shipped, "Order not yet shipped");
        require(!orders[_orderId].delivered, "Order already delivered");

        // Mark order as delivered
        Distributor(distributorAddress).receiveOrder(_orderId);
    }

    function getProductDetails(uint256 _productId) public view returns (string memory, string memory, address, bool, uint256, uint256, uint256, uint256, string memory, string memory, string memory) {
        return Producer(producerAddress).getProductDetails(_productId);
    }
}