import 'package:flutter_application_1/core/entities/product.dart';

import '../repositories/single_product_repository.dart';

/// Use case for fetching a single product by its ID.
class GetProductByIdUsecase {
  final SingleProductRepository _repo;

  const GetProductByIdUsecase(this._repo);

  Future<Product?> call(String id) {
    return _repo.getProductById(id);
  }
}
