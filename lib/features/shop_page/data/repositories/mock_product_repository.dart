import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/shop_page/domain/repositories/product_repository.dart';

class MockProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getAllProducts({
    int pageNumber = 0,
    int pageSize = 10,
    String? searchItem,
    bool sortDescending = false,
  }) async {
    return <Product>[];
  }
}
