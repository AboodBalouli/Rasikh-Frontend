import 'dart:typed_data';

import 'package:flutter_application_1/features/organization/domain/entities/product_rating.dart';
import 'package:flutter_application_1/features/organization/domain/entities/seller_metrics.dart';
import 'package:flutter_application_1/features/organization/domain/entities/seller_product.dart';

/// Abstract repository for seller product operations
abstract class SellerProductRepository {
  /// Get products for the current seller with pagination
  Future<List<SellerProduct>> getMyProducts({
    int pageNumber = 0,
    int pageSize = 10,
    String? searchItem,
    bool sortDescending = false,
  });

  /// Get a specific product by ID (owned by current seller)
  Future<SellerProduct> getMyProductById(int productId);

  /// Create a new product without images
  Future<SellerProduct> createProduct({
    required String name,
    required String description,
    required double price,
    List<String>? tags,
  });

  /// Create a new product with images
  Future<SellerProduct> createProductWithImages({
    required String name,
    required String description,
    required double price,
    required List<Uint8List> imageBytes,
    List<String>? tags,
  });

  /// Update an existing product
  Future<SellerProduct> updateProduct({
    required int productId,
    required String name,
    required String description,
    required double price,
    List<String>? tags,
  });

  /// Soft delete a product (hide it)
  Future<void> softDeleteProduct(int productId);

  /// Restore a soft-deleted product
  Future<SellerProduct> restoreProduct(int productId);

  /// Upload images for an existing product
  Future<void> uploadProductImages({
    required int productId,
    required List<Uint8List> imageBytes,
  });

  /// Get seller metrics
  Future<SellerMetrics> getSellerMetrics();

  /// Rate a product
  Future<ProductRating> rateProduct({
    required int productId,
    required int rating,
    String? comment,
  });

  /// Delete a product rating
  Future<void> deleteProductRating(int productId);

  /// Get all ratings for a product
  Future<List<ProductRating>> getProductRatings(int productId);

  /// Get products by seller ID (public)
  Future<List<SellerProduct>> getProductsBySellerId(String sellerId);
}
