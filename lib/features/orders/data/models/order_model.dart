enum OrderStatus { delivered, processing, cancelled }

class OrderModel {
  final String id;
  final String shopName;
  final String shopImageUrl;
  final String receivedAt;
  final List<OrderItem> items;
  final double totalPrice;
  final int rating;
  final OrderStatus status;

  OrderModel({
    required this.id,
    required this.shopName,
    required this.shopImageUrl,
    required this.receivedAt,
    required this.items,
    required this.totalPrice,
    required this.rating,
    required this.status,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}
