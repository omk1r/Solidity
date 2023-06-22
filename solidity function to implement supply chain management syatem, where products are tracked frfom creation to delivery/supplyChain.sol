//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract Supply{
    enum ProductStatus {CREATED,SHIPPED,DELIVERED}

    struct Product{
        uint256 ProductId;
        string name;
        address manufacturer;
        address distributor;
        address customer;
        ProductStatus status;
    }

    uint256 public productCount;
    mapping(uint256 => Product) public products;

    event ProductCreated(uint256 productId, string name);
    event ProductShipped(uint256 productId);
    event ProductDelivered(uint256 productId);

    function createProduct(string memory _name) public {
        uint256 productId = productCount + 1;
        products[productId] = Product(productId,_name,msg.sender,address(0),address(0),ProductStatus.CREATED);
        productCount ++;
        emit ProductCreated(productId,_name);
    }

    function shipProduct(uint256 _productId, address _distributor) public {
        require(products[_productId].status == ProductStatus.CREATED,"product is not created");
        require(products[_productId].manufacturer == msg.sender,"Only manufacturer can update the shipping");
        products[_productId].distributor = _distributor;
        products[_productId].status = ProductStatus.SHIPPED;
        emit ProductShipped(_productId);
    }

    function deliverProduct(uint256 _productId,address _customer) public {
        require(products[_productId].status == ProductStatus.SHIPPED,"product is not created");
        require(products[_productId].manufacturer == msg.sender,"Only manufacturer can update the shipping");
        products[_productId].customer = _customer;
        products[_productId].status = ProductStatus.DELIVERED;
        emit ProductDelivered(_productId);
    }
}