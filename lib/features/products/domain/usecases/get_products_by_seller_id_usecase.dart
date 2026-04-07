import 'package:flutter_application_1/core/entities/product.dart';

import '../repositories/product_repository.dart';

class GetProductsBySellerIdUsecase {
  final ProductRepository _repo;

  const GetProductsBySellerIdUsecase(this._repo);

  Future<List<Product>> call(String sellerId) {
    return _repo.getProductsBySellerId(sellerId);
  }
}
