class UpdateCartItemQuantityRequest {
  final int quantity;

  UpdateCartItemQuantityRequest({required this.quantity});

  Map<String, dynamic> toJson() {
    return {'quantity': quantity};
  }
}
