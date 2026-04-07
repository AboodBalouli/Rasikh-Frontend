import 'package:flutter_application_1/features/rating/domain/repositories/rating_repository.dart';

/// Use case for deleting the current user's product rating.
class DeleteProductRatingUseCase {
  final RatingRepository _repository;

  const DeleteProductRatingUseCase(this._repository);

  Future<void> call(int productId) {
    return _repository.deleteProductRating(productId);
  }
}
