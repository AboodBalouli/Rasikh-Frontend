import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';

abstract class PublicOrdersRepository {
  Future<List<PublicOrder>> fetchPublicOrders({
    required int pageNumber,
    int pageSize = 10,
  });

  Future<PublicOrder> fetchPublicOrderById(String id);

  Future<List<PublicOrder>> fetchMyPublicOrders();

  Future<List<PublicOrder>> fetchPublicOrdersByStatus({
    required String status,
    required int pageNumber,
    int pageSize = 10,
  });

  Future<PublicOrder> createPublicOrder(PublicOrder order);

  Future<PublicOrder> updatePublicOrder({
    required String id,
    String? title,
    String? description,
    String? imageUrl,
    String? location,
    String? phoneNumber,
    String? whatsappUrl,
  });

  Future<PublicOrder> updatePublicOrderStatus({
    required String id,
    required String status,
  });

  Future<void> deletePublicOrder(String id);

  Future<int> getMyOrdersCount();

  Future<void> uploadPublicOrderImages({
    required String publicOrderId,
    required List<String> filePaths,
  });

  /// Returns image paths for a public order from `/images/public-order/{publicOrderId}`.
  /// Useful when the order payload does not include an `imageUrl` field.
  Future<List<String>> fetchPublicOrderImagePaths(String publicOrderId);
}
