/// DTO for product rating list items from the backend.
class ProductRatingResponse {
  final int id;
  final int productId;
  final int? userId;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  const ProductRatingResponse({
    required this.id,
    required this.productId,
    this.userId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory ProductRatingResponse.fromJson(Map<String, dynamic> json) {
    return ProductRatingResponse(
      id: _parseIntOrDefault(json['id'], 0),
      productId: _parseIntOrDefault(json['productId'] ?? json['product_id'], 0),
      userId: _parseIntOrNull(json['userId'] ?? json['user_id']),
      rating: _parseIntOrDefault(json['rating'], 0),
      comment: json['comment'] as String?,
      createdAt: _parseDateTimeOrNow(json['createdAt'] ?? json['created_at']),
    );
  }

  static int _parseIntOrDefault(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static int? _parseIntOrNull(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static DateTime _parseDateTimeOrNow(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }
}
