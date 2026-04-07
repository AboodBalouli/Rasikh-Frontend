class OrderItemResponseModel {
  final int id;
  final int productId;
  final String productName;
  final String productDescription;
  final String productImagePath;
  final double price;
  final int quantity;
  final double subtotal;
  final int sellerProfileId;
  final String sellerFirstName;
  final String sellerLastName;

  const OrderItemResponseModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productImagePath,
    required this.price,
    required this.quantity,
    required this.subtotal,
    required this.sellerProfileId,
    required this.sellerFirstName,
    required this.sellerLastName,
  });

  factory OrderItemResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderItemResponseModel(
      id: (json['id'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      productName: (json['productName'] as String?) ?? '',
      productDescription: (json['productDescription'] as String?) ?? '',
      productImagePath: (json['productImagePath'] as String?) ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      sellerProfileId: (json['sellerProfileId'] as num?)?.toInt() ?? 0,
      sellerFirstName: (json['sellerFirstName'] as String?) ?? '',
      sellerLastName: (json['sellerLastName'] as String?) ?? '',
    );
  }
}
