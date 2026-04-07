import 'package:flutter_application_1/features/rating/domain/entities/store_rating.dart';
import 'package:flutter_application_1/features/rating/domain/repositories/rating_repository.dart';

/// Use case for rating a store/seller.
class RateStoreUseCase {
  final RatingRepository _repository;

  const RateStoreUseCase(this._repository);

  Future<StoreRating> call({
    required int sellerId,
    required int rating,
    String? comment,
  }) {
    return _repository.rateStore(
      sellerId: sellerId,
      rating: rating,
      comment: comment,
    );
  }
}
