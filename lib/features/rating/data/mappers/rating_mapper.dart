import 'package:flutter_application_1/features/rating/data/models/product_rating_response.dart';
import 'package:flutter_application_1/features/rating/data/models/store_rating_response.dart';
import 'package:flutter_application_1/features/rating/domain/entities/product_rating.dart';
import 'package:flutter_application_1/features/rating/domain/entities/store_rating.dart';

/// Maps ProductRatingResponse (DTO) to ProductRating (domain entity).
ProductRating mapProductRatingResponseToEntity(ProductRatingResponse response) {
  return ProductRating(
    id: response.id,
    productId: response.productId,
    userId: response.userId ?? 0,
    rating: response.rating,
    comment: response.comment,
    createdAt: response.createdAt,
  );
}

/// Maps StoreRatingResponse (DTO) to StoreRating (domain entity).
StoreRating mapStoreRatingResponseToEntity(StoreRatingResponse response) {
  return StoreRating(
    id: response.id,
    sellerId: response.sellerId,
    userId: response.userId,
    rating: response.rating,
    comment: response.comment,
    createdAt: response.createdAt,
  );
}
