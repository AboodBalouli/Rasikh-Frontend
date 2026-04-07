import 'cart_item.dart';

class Cart {
  final List<CartItem> items;
  final int totalItems;
  final double totalAmount;

  Cart({
    required this.items,
    required this.totalItems,
    required this.totalAmount,
  });
}
