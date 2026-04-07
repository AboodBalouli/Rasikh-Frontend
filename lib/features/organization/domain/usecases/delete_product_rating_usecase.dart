import 'package:flutter_application_1/features/organization/domain/repositories/seller_product_repository.dart';

/// Use case for deleting a product rating
class DeleteProductRatingUseCase {
  final SellerProductRepository repository;

  DeleteProductRatingUseCase(this.repository);

  Future<void> call(int productId) {
    return repository.deleteProductRating(productId);
  }
}
