import 'dart:typed_data';
import 'package:flutter_application_1/core/entities/product.dart';
import '../repositories/product_repository.dart';

/// Use case for creating a product with images.
class CreateProductUseCase {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  Future<Product> call({
    required String name,
    required String description,
    required double price,
    required List<String> tags,
    required List<Uint8List> images,
  }) {
    return repository.createProductWithImages(
      name: name,
      description: description,
      price: price,
      tags: tags,
      images: images,
    );
  }
}
