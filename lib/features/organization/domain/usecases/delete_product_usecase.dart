import 'package:flutter_application_1/features/organization/domain/repositories/seller_product_repository.dart';

/// Use case to soft delete a product
class DeleteProductUseCase {
  final SellerProductRepository repository;

  DeleteProductUseCase(this.repository);

  Future<void> call(int productId) {
    return repository.softDeleteProduct(productId);
  }
}
