import 'dart:typed_data';

import 'package:flutter_application_1/features/organization/domain/repositories/seller_product_repository.dart';

/// Use case to upload images for an existing product
class UploadProductImagesUseCase {
  final SellerProductRepository repository;

  UploadProductImagesUseCase(this.repository);

  Future<void> call({
    required int productId,
    required List<Uint8List> imageBytes,
  }) {
    return repository.uploadProductImages(
      productId: productId,
      imageBytes: imageBytes,
    );
  }
}
