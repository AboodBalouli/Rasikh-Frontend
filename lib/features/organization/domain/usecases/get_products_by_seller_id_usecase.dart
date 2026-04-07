import 'package:flutter_application_1/features/organization/domain/entities/seller_product.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/seller_product_repository.dart';

/// Use case for getting products by seller ID (public)
class GetProductsBySellerIdUseCase {
  final SellerProductRepository repository;

  GetProductsBySellerIdUseCase(this.repository);

  Future<List<SellerProduct>> call(String sellerId) {
    return repository.getProductsBySellerId(sellerId);
  }
}
