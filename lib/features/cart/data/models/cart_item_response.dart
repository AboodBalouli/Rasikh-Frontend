class CartItemResponse {
  final int id;
  final int productId;
  final String productName;
  final String productDescription;
  final num productPrice;
  final int quantity;
  final num subtotal;
  final String? productImagePath;
  final int sellerProfileId;
  final String sellerFirstName;
  final String sellerLastName;

  CartItemResponse({
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

  factory CartItemResponse.fromJson(Map<String, dynamic> json) {
    int readInt(String key) {
      final v = json[key];
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.parse(v.toString());
    }

    num readNum(String key) {
      final v = json[key];
      if (v is num) return v;
      return num.parse(v.toString());
    }

    String readString(String key) {
      final v = json[key];
      return (v ?? '').toString();
    }

    String? readNullableString(String key) {
      final v = json[key];
      if (v == null) return null;
      final s = v.toString();
      return s.trim().isEmpty ? null : s;
    }

    return CartItemResponse(
      id: readInt('id'),
      productId: readInt('productId'),
      productName: readString('productName'),
      productDescription: readString('productDescription'),
      productPrice: readNum('productPrice'),
      quantity: readInt('quantity'),
      subtotal: readNum('subtotal'),
      productImagePath: readNullableString('productImagePath'),
      sellerProfileId: readInt('sellerProfileId'),
      sellerFirstName: readString('sellerFirstName'),
      sellerLastName: readString('sellerLastName'),
    );
  }
}
