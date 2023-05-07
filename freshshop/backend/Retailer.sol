// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Producer.sol";
import "./Distributer.sol";


contract Retailer {
    address public producerAddress;
    address public distributorAddress;

    constructor(address _producerAddress, address _distributorAddress) {
        producerAddress = _producerAddress;
        distributorAddress = _distributorAddress;
    }

    function placeOrder(uint256 _productId, uint256 _quantity) public payable {
        // Fetch product details from Producer contract
        (, , , , uint256 quantity, uint256 price, , , , , ) = Producer(producerAddress).getProductDetails(_productId);
        require(quantity >= _quantity, "Insufficient quantity available");

        // Calculate total price and transfer funds to distributor
        uint256 totalPrice = price * _quantity;
        require(msg.value >= totalPrice, "Insufficient funds sent");
        (bool sent, ) = distributorAddress.call{value: totalPrice}("");
        require(sent, "Payment failed");

        // Place order with distributor
        Distributor(distributorAddress).placeOrder(_productId, _quantity);
    }

    function getShipmentStatus(uint256 _orderId) public view returns (bool, bool) {
        return Distributor(distributorAddress).orders(_orderId).shipped;
    }

    function confirmReceipt(uint256 _orderId) public {
        require(msg.sender == Distributor(distributorAddress).orders(_orderId).buyer(), "Only the buyer can confirm receipt");
        Distributor(distributorAddress).receiveOrder(_orderId);
    }
}