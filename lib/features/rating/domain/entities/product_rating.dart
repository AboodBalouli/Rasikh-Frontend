/// Domain entity representing a product rating.
class ProductRating {
  final int id;
  final int productId;
  final int userId;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  const ProductRating({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });
}
