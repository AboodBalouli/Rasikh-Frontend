import 'package:flutter_application_1/features/rating/domain/entities/product_rating.dart';
import 'package:flutter_application_1/features/rating/domain/repositories/rating_repository.dart';

/// Use case for rating a product.
class RateProductUseCase {
  final RatingRepository _repository;

  const RateProductUseCase(this._repository);

  Future<ProductRating> call({
    required int productId,
    required int rating,
    String? comment,
  }) {
    return _repository.rateProduct(
      productId: productId,
      rating: rating,
      comment: comment,
    );
  }
}
