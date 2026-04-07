/// Domain entity representing a product rating
class ProductRating {
  final int? ratingId;
  final int productId;
  final int userId;
  final int rating;
  final String? comment;
  final DateTime? createdAt;

  const ProductRating({
    this.ratingId,
    required this.productId,
    required this.userId,
    required this.rating,
    this.comment,
    this.createdAt,
  });

  ProductRating copyWith({
    int? ratingId,
    int? productId,
    int? userId,
    int? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return ProductRating(
      ratingId: ratingId ?? this.ratingId,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
