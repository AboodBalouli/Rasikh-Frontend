import 'package:flutter_application_1/features/rating/domain/entities/product_rating.dart';
import 'package:flutter_application_1/features/rating/domain/entities/store_rating.dart';

/// Abstract contract for rating operations.
abstract class RatingRepository {
  /// Rate a product (1-5 stars with optional comment).
  /// Returns the created/updated rating.
  Future<ProductRating> rateProduct({
    required int productId,
    required int rating,
    String? comment,
  });

  /// Delete the current user's rating for a product.
  Future<void> deleteProductRating(int productId);

  /// Fetch all ratings for a product.
  Future<List<ProductRating>> fetchProductRatings(int productId);

  /// Rate a store/seller (1-5 stars with optional comment).
  /// Returns the created/updated rating.
  Future<StoreRating> rateStore({
    required int sellerId,
    required int rating,
    String? comment,
  });

  /// Fetch all ratings for a store/seller.
  Future<List<StoreRating>> fetchStoreRatings(int sellerId);
}
