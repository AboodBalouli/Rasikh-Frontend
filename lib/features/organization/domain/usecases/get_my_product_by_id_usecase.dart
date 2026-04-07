import 'package:flutter_application_1/features/organization/domain/entities/seller_product.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/seller_product_repository.dart';

/// Use case to get a specific product by ID (owned by current seller)
class GetMyProductByIdUseCase {
  final SellerProductRepository repository;

  GetMyProductByIdUseCase(this.repository);

  Future<SellerProduct> call(int productId) {
    return repository.getMyProductById(productId);
  }
}
