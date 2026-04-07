import 'package:flutter_application_1/features/organization/domain/entities/product_rating.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/seller_product_repository.dart';

/// Use case for getting all ratings for a product
class GetProductRatingsUseCase {
  final SellerProductRepository repository;

  GetProductRatingsUseCase(this.repository);

  Future<List<ProductRating>> call(int productId) {
    return repository.getProductRatings(productId);
  }
}
