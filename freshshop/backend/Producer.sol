// SPDX-License-Identifier:  GPL-3.0


pragma solidity ^0.8.0;

contract Producer {
    struct Product {
        string name;
        string description;
        address owner;
        bool certifiedOrganic;
        uint256 quantity;
        uint256 price;
        uint256 harvestDate;
        uint256 certificationDate;
        string location;
        string imageHash;
        string videoHash;
    }

    mapping(uint256 => Product) public products;
    uint256 public productId = 0;

    function addProduct(string memory _name, string memory _description, bool _certifiedOrganic, uint256 _quantity, uint256 _price, uint256 _harvestDate, string memory _location, string memory _imageHash, string memory _videoHash) public returns (uint256) {
        productId++;
        products[productId] = Product(_name, _description, msg.sender, _certifiedOrganic, _quantity, _price, _harvestDate, 0, _location, _imageHash, _videoHash);
        return productId;
    }

    function getProductDetails(uint256 _productId) public view returns (string memory, string memory, address, bool, uint256, uint256, uint256, uint256, string memory, string memory, string memory) {
        Product memory p = products[_productId];
        return (p.name, p.description, p.owner, p.certifiedOrganic, p.quantity, p.price, p.harvestDate, p.certificationDate, p.location, p.imageHash, p.videoHash);
    }

    function updateProductStatus(uint256 _productId, bool _certifiedOrganic, uint256 _certificationDate) public {
        require(products[_productId].owner == msg.sender, "Only the product owner can update the status");
        products[_productId].certifiedOrganic = _certifiedOrganic;
        products[_productId].certificationDate = _certificationDate;
    }

    function transferProduct(uint256 _productId, address _newOwner) public {
        require(products[_productId].owner == msg.sender, "Only the product owner can transfer ownership");
        products[_productId].owner = _newOwner;
    }
}