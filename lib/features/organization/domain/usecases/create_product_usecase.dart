import 'dart:typed_data';

import 'package:flutter_application_1/features/organization/domain/entities/seller_product.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/seller_product_repository.dart';

/// Use case to create a new product
class CreateProductUseCase {
  final SellerProductRepository repository;

  CreateProductUseCase(this.repository);

  /// Creates a product without images
  Future<SellerProduct> call({
    required String name,
    required String description,
    required double price,
    List<String>? tags,
  }) {
    return repository.createProduct(
      name: name,
      description: description,
      price: price,
      tags: tags,
    );
  }

  /// Creates a product with images
  Future<SellerProduct> withImages({
    required String name,
    required String description,
    required double price,
    required List<Uint8List> imageBytes,
    List<String>? tags,
  }) {
    return repository.createProductWithImages(
      name: name,
      description: description,
      price: price,
      imageBytes: imageBytes,
      tags: tags,
    );
  }
}
