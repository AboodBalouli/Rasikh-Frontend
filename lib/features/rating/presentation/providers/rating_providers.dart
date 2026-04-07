import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/app/dependency_injection/rating_dependency_injection.dart';
import 'package:flutter_application_1/features/rating/domain/entities/product_rating.dart';
import 'package:flutter_application_1/features/rating/domain/entities/store_rating.dart';
import 'package:flutter_application_1/features/rating/domain/usecases/rate_product_usecase.dart';
import 'package:flutter_application_1/features/rating/domain/usecases/rate_store_usecase.dart';
import 'package:flutter_application_1/features/rating/domain/usecases/delete_product_rating_usecase.dart';
import 'package:flutter_application_1/features/rating/domain/usecases/fetch_product_ratings_usecase.dart';
import 'package:flutter_application_1/features/rating/domain/usecases/fetch_store_ratings_usecase.dart';

// ============================================================================
// USE CASE PROVIDERS
// ============================================================================

final rateProductUseCaseProvider = Provider<RateProductUseCase>((ref) {
  final repo = ref.watch(ratingRepositoryProvider);
  return RateProductUseCase(repo);
});

final rateStoreUseCaseProvider = Provider<RateStoreUseCase>((ref) {
  final repo = ref.watch(ratingRepositoryProvider);
  return RateStoreUseCase(repo);
});

final deleteProductRatingUseCaseProvider = Provider<DeleteProductRatingUseCase>(
  (ref) {
    final repo = ref.watch(ratingRepositoryProvider);
    return DeleteProductRatingUseCase(repo);
  },
);

final fetchProductRatingsUseCaseProvider = Provider<FetchProductRatingsUseCase>(
  (ref) {
    final repo = ref.watch(ratingRepositoryProvider);
    return FetchProductRatingsUseCase(repo);
  },
);

final fetchStoreRatingsUseCaseProvider = Provider<FetchStoreRatingsUseCase>((
  ref,
) {
  final repo = ref.watch(ratingRepositoryProvider);
  return FetchStoreRatingsUseCase(repo);
});

// ============================================================================
// DATA PROVIDERS
// ============================================================================

/// Fetches all ratings for a product by productId.
final productRatingsProvider = FutureProvider.family<List<ProductRating>, int>((
  ref,
  productId,
) async {
  final usecase = ref.watch(fetchProductRatingsUseCaseProvider);
  return usecase(productId);
});

/// Fetches all ratings for a store/seller by sellerId.
final storeRatingsProvider = FutureProvider.family<List<StoreRating>, int>((
  ref,
  sellerId,
) async {
  final usecase = ref.watch(fetchStoreRatingsUseCaseProvider);
  return usecase(sellerId);
});
