import 'package:flutter_application_1/features/public_orders/data/models/public_order_response.dart';
import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';

String? _normalizeImageUrl(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;

  // Some backends/dev seeds use placeholder example.com URLs.
  // Treat them as "no image" to avoid noisy NetworkImage errors.
  final uri = Uri.tryParse(trimmed);
  if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
    final host = uri.host.toLowerCase();
    if (host == 'example.com' || host.endsWith('.example.com')) {
      return null;
    }
  }

  return trimmed;
}

PublicOrder mapOrderResponseToPublicOrder(PublicOrderResponse response) {
  return PublicOrder(
    id: response.id,
    userId: response.userId,
    title: response.title,
    description: response.description,
    customerFirstName: response.customerFirstName,
    customerLastName: response.customerLastName,
    imageUrl: _normalizeImageUrl(response.imageUrl),
    location: response.location,
    phoneNumber: response.phoneNumber,
    whatsappUrl: response.whatsappUrl,
    status: response.status,
    orderDate: DateTime.parse(response.createdAt),
    updatedAt: response.updatedAt != null
        ? DateTime.parse(response.updatedAt!)
        : null,
  );
}
