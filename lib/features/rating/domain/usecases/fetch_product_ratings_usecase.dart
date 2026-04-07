import 'package:flutter_application_1/features/rating/domain/entities/product_rating.dart';
import 'package:flutter_application_1/features/rating/domain/repositories/rating_repository.dart';

/// Use case for fetching all ratings for a product.
class FetchProductRatingsUseCase {
  final RatingRepository _repository;

  const FetchProductRatingsUseCase(this._repository);

  Future<List<ProductRating>> call(int productId) {
    return _repository.fetchProductRatings(productId);
  }
}
