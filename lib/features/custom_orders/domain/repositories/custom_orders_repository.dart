import '../entities/custom_order.dart';

/// Abstract repository contract for custom orders.
abstract class CustomOrdersRepository {
  /// Create a new custom order request (USER).
  Future<CustomOrder> createCustomOrder({
    required String sellerProfileId,
    required String title,
    required String description,
    required String location,
    required String phoneNumber,
    required String whatsappUrl,
    List<String>? imagePaths,
  });

  /// Get customer's own custom orders (USER).
  Future<List<CustomOrder>> getMyCustomOrders();

  /// Get custom order by ID (USER or SELLER).
  Future<CustomOrder> getCustomOrderById(String id);

  /// Update custom order (USER, only when PENDING).
  Future<CustomOrder> updateCustomOrder({
    required String id,
    String? title,
    String? description,
    String? location,
  });

  /// Cancel custom order (USER).
  Future<CustomOrder> cancelCustomOrder(String id);

  /// Accept seller's quote (USER, only when QUOTED).
  Future<CustomOrder> acceptQuote(String id);

  /// Get seller's inbox - requests assigned to them (SELLER).
  Future<List<CustomOrder>> getSellerInbox();

  /// Quote a custom order request (SELLER).
  Future<CustomOrder> quoteCustomOrder({
    required String id,
    required double quotedPrice,
    required int estimatedDays,
    String? sellerNote,
  });

  /// Reject a custom order request (SELLER).
  Future<CustomOrder> rejectCustomOrder(String id);
}
