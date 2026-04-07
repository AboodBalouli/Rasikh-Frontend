/// DTO for store rating list items from the backend.
class StoreRatingResponse {
  final int id;
  final int sellerId;
  final int? userId;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  const StoreRatingResponse({
    required this.id,
    required this.sellerId,
    this.userId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory StoreRatingResponse.fromJson(Map<String, dynamic> json) {
    return StoreRatingResponse(
      id: _parseIntOrDefault(json['id'], 0),
      sellerId: _parseIntOrDefault(
        json['sellerId'] ?? json['sellerProfileId'] ?? json['seller_id'],
        0,
      ),
      userId: json['userId'] != null ? _parseIntOrNull(json['userId']) : null,
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
