import 'order_item.dart';
import 'order_status.dart';

class Order {
  final int orderId;
  final OrderStatus status;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String shippingAddress;
  final String phoneNumber;
  final String? notes;

  final int userId;
  final String userEmail;
  final String userFirstName;
  final String userLastName;

  final List<OrderItem> items;
  final int totalItems;

  const Order({
    required this.orderId,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.shippingAddress,
    required this.phoneNumber,
    required this.notes,
    required this.userId,
    required this.userEmail,
    required this.userFirstName,
    required this.userLastName,
    required this.items,
    required this.totalItems,
  });
}
