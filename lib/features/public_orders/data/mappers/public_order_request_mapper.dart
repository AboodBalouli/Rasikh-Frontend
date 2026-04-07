import 'package:flutter_application_1/features/public_orders/data/models/public_order_request.dart';
import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';

PublicOrderRequest mapPublicOrderToOrderRequest(PublicOrder order) {
  return PublicOrderRequest(
    title: order.title,
    description: order.description,
    imageUrl: order.imageUrl,
    location: order.location,
    phoneNumber: order.phoneNumber,
    whatsappUrl: order.whatsappUrl,
  );
}