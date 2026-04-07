import 'package:flutter_application_1/features/organization/domain/entities/seller_product.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/seller_product_repository.dart';

/// Use case to update an existing product
class UpdateProductUseCase {
  final SellerProductRepository repository;

  UpdateProductUseCase(this.repository);

  Future<SellerProduct> call({
    required int productId,
    required String name,
    required String description,
    required double price,
    List<String>? tags,
  }) {
    return repository.updateProduct(
      productId: productId,
      name: name,
      description: description,
      price: price,
      tags: tags,
    );
  }
}
