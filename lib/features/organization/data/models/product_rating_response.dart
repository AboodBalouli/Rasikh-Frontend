/// Response model for product ratings
/// From GET /api/product/{productId}/ratings and POST /api/product/rate
class ProductRatingResponse {
  final int? ratingId;
  final int productId;
  final int userId;
  final int rating;
  final String? comment;
  final String? createdAt;

  const ProductRatingResponse({
    this.ratingId,
    required this.productId,
    required this.userId,
    required this.rating,
    this.comment,
    this.createdAt,
  });

  factory ProductRatingResponse.fromJson(Map<String, dynamic> json) {
    return ProductRatingResponse(
      ratingId: json['ratingId'] as int?,
      productId: (json['productId'] ?? 0) as int,
      userId: (json['userId'] ?? 0) as int,
      rating: (json['rating'] ?? 0) as int,
      comment: json['comment'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }
}
