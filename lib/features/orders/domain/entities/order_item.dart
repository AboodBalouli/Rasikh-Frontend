class OrderItem {
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

  const OrderItem({
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
}
