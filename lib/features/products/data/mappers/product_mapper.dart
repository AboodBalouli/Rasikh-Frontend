import 'package:flutter_application_1/core/entities/product.dart' as domain;

import '../models/product_model.dart';

class ProductMapper {
  static domain.Product toDomain(ProductModel model) {
    return domain.Product(
      id: model.id,
      name: model.title,
      description: model.description ?? '',
      price: double.tryParse(model.price) ?? 0.0,
      imageUrl: model.imageUrl ?? '',
      imageUrls: model.imageUrls,
      sellerId: model.sellerId ?? '',
      category: model.category ?? '',
      isCustomizable: model.isCustomizable ?? false,
      rating: model.rating ?? 0.0,
      reviewCount: model.reviewCount ?? 0,
      imagePaths: model.imagePaths,
    );
  }
}
