import 'order_item_response_model.dart';

class OrderResponseModel {
  final int orderId;
  final String status;
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

  final List<OrderItemResponseModel> items;
  final int totalItems;

  const OrderResponseModel({
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

  static DateTime _parseDate(Object? value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
              .whereType<Map>()
              .map(
                (e) =>
                    OrderItemResponseModel.fromJson(e.cast<String, dynamic>()),
              )
              .toList()
        : <OrderItemResponseModel>[];

    return OrderResponseModel(
      orderId: (json['orderId'] as num).toInt(),
      status: (json['status'] as String?) ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      shippingAddress: (json['shippingAddress'] as String?) ?? '',
      phoneNumber: (json['phoneNumber'] as String?) ?? '',
      notes: json['notes'] as String?,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      userEmail: (json['userEmail'] as String?) ?? '',
      userFirstName: (json['userFirstName'] as String?) ?? '',
      userLastName: (json['userLastName'] as String?) ?? '',
      items: items,
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
    );
  }
}
