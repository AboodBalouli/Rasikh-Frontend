/// Request model for rating a product
/// POST /api/product/rate
class ProductRatingRequest {
  final int productId;
  final int rating; // 1-5
  final String? comment;

  const ProductRatingRequest({
    required this.productId,
    required this.rating,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'rating': rating,
      if (comment != null) 'comment': comment,
    };
  }
}
