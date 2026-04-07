import 'dart:typed_data';
import 'package:flutter_application_1/core/entities/product.dart';

/// Domain-level repository interface for products.
abstract class ProductRepository {
  Future<List<Product>> getProducts();

  /// Backend: GET /api/product/sellers-products/{sellerId}
  Future<List<Product>> getProductsBySellerId(String sellerId);

  /// Backend: POST /api/product/create-with-images
  Future<Product> createProductWithImages({
    required String name,
    required String description,
    required double price,
    required List<String> tags,
    required List<Uint8List> images,
  });
}
