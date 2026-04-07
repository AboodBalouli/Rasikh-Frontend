class CartItem {
  final int id;
  final int productId;
  final String productName;
  final String productDescription;
  final double productPrice;
  final int quantity;
  final double subtotal;
  final String productImagePath;
  final int sellerProfileId;
  final String sellerFirstName;
  final String sellerLastName;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.quantity,
    required this.subtotal,
    required this.productImagePath,
    required this.sellerProfileId,
    required this.sellerFirstName,
    required this.sellerLastName,
  });
}

/**
 *  "id": 1,
    "productId": 12,
    "productName": "Product name",
    "productDescription": "Product description",
    "productPrice": 9.99,
    "quantity": 4,
    "subtotal": 39.96,
    "productImagePath": "/images/product/abc-123.png",
    "sellerProfileId": 7,
    "sellerFirstName": "Seller",
    "sellerLastName": "Name"
 */
