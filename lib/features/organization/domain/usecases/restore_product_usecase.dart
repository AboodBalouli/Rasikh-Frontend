import 'package:flutter_application_1/features/organization/domain/entities/seller_product.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/seller_product_repository.dart';

/// Use case to restore a soft-deleted product
class RestoreProductUseCase {
  final SellerProductRepository repository;

  RestoreProductUseCase(this.repository);

  Future<SellerProduct> call(int productId) {
    return repository.restoreProduct(productId);
  }
}
