class AddCartItemRequest {
  final int productId;
  final int quantity;

  AddCartItemRequest({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'quantity': quantity};
  }
}
