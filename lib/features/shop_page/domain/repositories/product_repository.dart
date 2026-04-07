import 'package:flutter_application_1/core/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts({
    int pageNumber = 0,
    int pageSize = 10,
    String? searchItem,
    bool sortDescending = false,
  });
}
