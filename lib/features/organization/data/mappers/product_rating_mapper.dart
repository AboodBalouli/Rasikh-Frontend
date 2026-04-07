import 'package:flutter_application_1/features/organization/data/models/product_rating_response.dart';
import 'package:flutter_application_1/features/organization/domain/entities/product_rating.dart';

/// Maps ProductRatingResponse to ProductRating entity
ProductRating mapProductRatingResponseToEntity(ProductRatingResponse response) {
  return ProductRating(
    ratingId: response.ratingId,
    productId: response.productId,
    userId: response.userId,
    rating: response.rating,
    comment: response.comment,
    createdAt: response.createdAt != null
        ? DateTime.tryParse(response.createdAt!)
        : null,
  );
}

/// Maps list of responses to list of entities
List<ProductRating> mapProductRatingResponseListToEntities(
  List<ProductRatingResponse> responses,
) {
  return responses.map(mapProductRatingResponseToEntity).toList();
}
