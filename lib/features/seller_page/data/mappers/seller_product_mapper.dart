import 'package:flutter_application_1/features/seller_page/data/models/seller_product_response.dart';
import 'package:flutter_application_1/features/seller_page/domain/entities/seller_product.dart';

SellerProduct mapSellerProductResponseToEntity(SellerProductResponse model) {
  return SellerProduct(
    id: model.id,
    title: model.title,
    price: model.price,
    description: model.description,
    imageUrl: model.imageUrl,
    category: model.category,
    tags: model.tags,
    imagePaths: model.imagePaths,
  );
}
