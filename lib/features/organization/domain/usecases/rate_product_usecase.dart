import 'package:flutter_application_1/features/organization/domain/entities/product_rating.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/seller_product_repository.dart';

/// Use case for rating a product
class RateProductUseCase {
  final SellerProductRepository repository;

  RateProductUseCase(this.repository);

  Future<ProductRating> call({
    required int productId,
    required int rating,
    String? comment,
  }) {
    return repository.rateProduct(
      productId: productId,
      rating: rating,
      comment: comment,
    );
  }
}
