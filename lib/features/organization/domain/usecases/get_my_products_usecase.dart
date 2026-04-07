import 'package:flutter_application_1/features/organization/domain/entities/seller_product.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/seller_product_repository.dart';

/// Use case to get products for the current seller with pagination
class GetMyProductsUseCase {
  final SellerProductRepository repository;

  GetMyProductsUseCase(this.repository);

  Future<List<SellerProduct>> call({
    int pageNumber = 0,
    int pageSize = 10,
    String? searchItem,
    bool sortDescending = false,
  }) {
    return repository.getMyProducts(
      pageNumber: pageNumber,
      pageSize: pageSize,
      searchItem: searchItem,
      sortDescending: sortDescending,
    );
  }
}
