import 'package:flutter_application_1/features/organization/data/models/seller_product_response.dart';
import 'package:flutter_application_1/features/organization/domain/entities/seller_product.dart';

/// Maps SellerProductResponse to SellerProduct entity
SellerProduct mapSellerProductResponseToEntity(SellerProductResponse response) {
  return SellerProduct(
    id: response.id,
    name: response.name,
    description: response.description,
    price: response.price,
    rating: response.rating,
    ratingCount: response.ratingCount,
    categoryName: response.category?.name,
    imagePaths: response.imagePaths,
    tags: response.tags,
    totalSales: response.totalSales,
    sellerProfileId: response.sellerProfileId,
    isVisible: !response.isDeleted, // inverse: deleted=true means visible=false
  );
}

/// Maps list of responses to list of entities
List<SellerProduct> mapSellerProductResponseListToEntities(
  List<SellerProductResponse> responses,
) {
  return responses.map(mapSellerProductResponseToEntity).toList();
}
