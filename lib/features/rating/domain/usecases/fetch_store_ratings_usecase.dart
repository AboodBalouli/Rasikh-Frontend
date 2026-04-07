import 'package:flutter_application_1/features/rating/domain/entities/store_rating.dart';
import 'package:flutter_application_1/features/rating/domain/repositories/rating_repository.dart';

/// Use case for fetching all ratings for a store/seller.
class FetchStoreRatingsUseCase {
  final RatingRepository _repository;

  const FetchStoreRatingsUseCase(this._repository);

  Future<List<StoreRating>> call(int sellerId) {
    return _repository.fetchStoreRatings(sellerId);
  }
}
