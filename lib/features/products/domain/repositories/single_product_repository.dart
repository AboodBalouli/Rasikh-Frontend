import 'package:flutter_application_1/core/entities/product.dart';

/// Domain-level repository interface for a single product.
abstract class SingleProductRepository {
  Future<Product?> getProductById(String id);
}
