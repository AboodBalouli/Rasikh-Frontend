import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/features/rating/data/datasources/rating_remote_datasource.dart';
import 'package:flutter_application_1/features/rating/data/mappers/rating_mapper.dart';
import 'package:flutter_application_1/features/rating/data/models/rate_product_request.dart';
import 'package:flutter_application_1/features/rating/data/models/rate_store_request.dart';
import 'package:flutter_application_1/features/rating/domain/entities/product_rating.dart';
import 'package:flutter_application_1/features/rating/domain/entities/store_rating.dart';
import 'package:flutter_application_1/features/rating/domain/entities/rating_exception.dart';
import 'package:flutter_application_1/features/rating/domain/repositories/rating_repository.dart';

/// Concrete implementation of [RatingRepository].
class RatingRepositoryImpl implements RatingRepository {
  final RatingRemoteDatasource remote;
  final TokenProvider tokenProvider;

  RatingRepositoryImpl({required this.remote, required this.tokenProvider});

  Future<String> _requireToken() async {
    final token = await tokenProvider.getToken();
    if (token == null || token.isEmpty) {
      throw const RatingException('Not authenticated. Please login again');
    }
    return token;
  }

  @override
  Future<ProductRating> rateProduct({
    required int productId,
    required int rating,
    String? comment,
  }) async {
    final token = await _requireToken();
    final request = RateProductRequest(
      productId: productId,
      rating: rating,
      comment: comment,
    );

    final apiResponse = await remote.rateProduct(
      token: token,
      request: request,
    );

    if (apiResponse.success && apiResponse.data != null) {
      // Backend returns the rating info; construct entity from response
      final data = apiResponse.data!;
      return ProductRating(
        id: 0, // ID might not be in immediate response
        productId: productId,
        userId: (data['userId'] as num?)?.toInt() ?? 0,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );
    }

    final message = apiResponse.error?.message ?? 'Failed to rate product';
    throw RatingException(message);
  }

  @override
  Future<void> deleteProductRating(int productId) async {
    final token = await _requireToken();
    final apiResponse = await remote.deleteProductRating(
      token: token,
      productId: productId,
    );

    if (apiResponse.success) return;

    final message = apiResponse.error?.message ?? 'Failed to delete rating';
    throw RatingException(message);
  }

  @override
  Future<List<ProductRating>> fetchProductRatings(int productId) async {
    final apiResponse = await remote.getProductRatings(productId: productId);

    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!.map(mapProductRatingResponseToEntity).toList();
    }

    final message = apiResponse.error?.message ?? 'Failed to fetch ratings';
    throw RatingException(message);
  }

  @override
  Future<StoreRating> rateStore({
    required int sellerId,
    required int rating,
    String? comment,
  }) async {
    final token = await _requireToken();
    final request = RateStoreRequest(rating: rating, comment: comment);

    final apiResponse = await remote.rateStore(
      token: token,
      sellerProfileId: sellerId,
      request: request,
    );

    if (apiResponse.success && apiResponse.data != null) {
      final data = apiResponse.data!;
      return StoreRating(
        id: 0,
        sellerId: sellerId,
        userId: (data['userId'] as num?)?.toInt(),
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );
    }

    final message = apiResponse.error?.message ?? 'Failed to rate store';
    throw RatingException(message);
  }

  @override
  Future<List<StoreRating>> fetchStoreRatings(int sellerId) async {
    final apiResponse = await remote.getStoreRatings(sellerProfileId: sellerId);

    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!.map(mapStoreRatingResponseToEntity).toList();
    }

    final message = apiResponse.error?.message ?? 'Failed to fetch ratings';
    throw RatingException(message);
  }
}
