import 'package:flutter_application_1/features/cart/data/models/cart_item_response.dart';

class CartResponse {
  final List<CartItemResponse> items;
  final int totalItems;
  final num totalAmount;

  CartResponse({
    required this.items,
    required this.totalItems,
    required this.totalAmount,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>?) ?? const [];
    return CartResponse(
      items: itemsJson
          .map((itemJson) {
            final map = (itemJson as Map).cast<String, dynamic>();
            return CartItemResponse.fromJson(map);
          })
          .toList(growable: false),
      totalItems: json['totalItems'] as int,
      totalAmount: json['totalAmount'] as num,
    );
  }
}
