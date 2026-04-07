/// Domain entity representing a store/seller rating.
class StoreRating {
  final int id;
  final int sellerId;
  final int? userId;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  const StoreRating({
    required this.id,
    required this.sellerId,
    this.userId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });
}
