/// Request body for POST /api/product/rate
class RateProductRequest {
  final int productId;
  final int rating;
  final String? comment;

  const RateProductRequest({
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
