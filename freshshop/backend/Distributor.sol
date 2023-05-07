// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "./Producer.sol";


contract Distributor {

    
    constructor(address _producerAddress) {
    producerAddress = _producerAddress;
}

    

    struct Order {
      
        uint256 productId;
        uint256 quantity;
        uint256 totalPrice;
        address buyer;
        bool shipped;
        bool delivered;
    }

    mapping(uint256 => Order) public orders;
    uint256 public orderId = 0;

    address public producerAddress;

    

    function placeOrder(uint256 _productId, uint256 _quantity) public payable {
        require(msg.value > 0, "Payment required");

        // Fetch product details from Producer contract
        (, , , , uint256 quantity, uint256 price, , , , , ) = Producer(producerAddress).getProductDetails(_productId);
        require(quantity >= _quantity, "Insufficient quantity available");

        // Calculate total price and transfer funds to producer
        uint256 totalPrice = price * _quantity;
        require(msg.value >= totalPrice, "Insufficient funds sent");
        (bool sent, ) = producerAddress.call{value: totalPrice}("");
        require(sent, "Payment failed");

        // Create new order
        orderId++;
        orders[orderId] = Order(_productId, _quantity, totalPrice, msg.sender, false, false);
    }

    function shipOrder(uint256 _orderId) public {
        require(msg.sender == producerAddress, "Only the producer can mark an order as shipped");
        require(orders[_orderId].productId != 0, "Invalid order ID");
        require(!orders[_orderId].shipped, "Order already shipped");

        orders[_orderId].shipped = true;
    }

    function receiveOrder(uint256 _orderId) public {
        require(orders[_orderId].buyer == msg.sender, "Only the buyer can receive the order");
        require(orders[_orderId].shipped, "Order not yet shipped");
        require(!orders[_orderId].delivered, "Order already delivered");

        orders[_orderId].delivered = true;
    }
}