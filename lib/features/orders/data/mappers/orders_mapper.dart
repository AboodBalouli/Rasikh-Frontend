import 'package:flutter_application_1/features/orders/domain/entities/order.dart';
import 'package:flutter_application_1/features/orders/domain/entities/order_item.dart';
import 'package:flutter_application_1/features/orders/domain/entities/order_status.dart';
import '../models/order_item_response_model.dart';
import '../models/order_response_model.dart';

// Intentionally kept as simple functions (pure mappers)

OrderStatus mapOrderStatusStringToDomain(String status) {
  switch (status.toUpperCase()) {
    case 'PENDING':
      return OrderStatus.pending;
    case 'PAID':
      return OrderStatus.paid;
    case 'SHIPPED':
      return OrderStatus.shipped;
    case 'COMPLETED':
      return OrderStatus.completed;
    case 'CANCELED':
    case 'CANCELLED':
      return OrderStatus.canceled;
    default:
      return OrderStatus.pending;
  }
}

String mapOrderStatusDomainToApi(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return 'PENDING';
    case OrderStatus.paid:
      return 'PAID';
    case OrderStatus.shipped:
      return 'SHIPPED';
    case OrderStatus.completed:
      return 'COMPLETED';
    case OrderStatus.canceled:
      return 'CANCELED';
  }
}

OrderItem mapOrderItemResponseToDomain(OrderItemResponseModel m) {
  return OrderItem(
    id: m.id,
    productId: m.productId,
    productName: m.productName,
    productDescription: m.productDescription,
    productImagePath: m.productImagePath,
    price: m.price,
    quantity: m.quantity,
    subtotal: m.subtotal,
    sellerProfileId: m.sellerProfileId,
    sellerFirstName: m.sellerFirstName,
    sellerLastName: m.sellerLastName,
  );
}

Order mapOrderResponseToDomain(OrderResponseModel m) {
  return Order(
    orderId: m.orderId,
    status: mapOrderStatusStringToDomain(m.status),
    totalAmount: m.totalAmount,
    createdAt: m.createdAt,
    updatedAt: m.updatedAt,
    shippingAddress: m.shippingAddress,
    phoneNumber: m.phoneNumber,
    notes: m.notes,
    userId: m.userId,
    userEmail: m.userEmail,
    userFirstName: m.userFirstName,
    userLastName: m.userLastName,
    items: m.items.map(mapOrderItemResponseToDomain).toList(),
    totalItems: m.totalItems,
  );
}
