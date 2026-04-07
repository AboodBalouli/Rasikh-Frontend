import 'dart:typed_data';

import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/features/organization/data/datasources/seller_product_remote_datasource.dart';
import 'package:flutter_application_1/features/organization/data/mappers/product_rating_mapper.dart';
import 'package:flutter_application_1/features/organization/data/mappers/seller_metrics_mapper.dart';
import 'package:flutter_application_1/features/organization/data/mappers/seller_product_mapper.dart';
import 'package:flutter_application_1/features/organization/data/models/product_rating_request.dart';
import 'package:flutter_application_1/features/organization/data/models/seller_product_request.dart';
import 'package:flutter_application_1/features/organization/domain/entities/organization_exception.dart';
import 'package:flutter_application_1/features/organization/domain/entities/product_rating.dart';
import 'package:flutter_application_1/features/organization/domain/entities/seller_metrics.dart';
import 'package:flutter_application_1/features/organization/domain/entities/seller_product.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/seller_product_repository.dart';

class SellerProductRepositoryImpl implements SellerProductRepository {
  final SellerProductRemoteDatasource remote;
  final TokenProvider tokenProvider;

  SellerProductRepositoryImpl({
    required this.remote,
    required this.tokenProvider,
  });

  Future<String> _requireToken() async {
    final token = await tokenProvider.getToken();
    if (token == null || token.isEmpty) {
      throw const OrganizationException('Not authenticated. Please login');
    }
    return token;
  }

  @override
  Future<List<SellerProduct>> getMyProducts({
    int pageNumber = 0,
    int pageSize = 10,
    String? searchItem,
    bool sortDescending = false,
  }) async {
    print(
      '[DEBUG] getMyProducts called with pageNumber=$pageNumber, pageSize=$pageSize',
    );
    try {
      final token = await _requireToken();
      print('[DEBUG] Got token: ${token.substring(0, 20)}...');
      final apiResponse = await remote.getMyProducts(
        token: token,
        pageNumber: pageNumber,
        pageSize: pageSize,
        searchItem: searchItem,
        sortDescending: sortDescending,
      );
      print(
        '[DEBUG] API Response success=${apiResponse.success}, data=${apiResponse.data?.length ?? 0} items',
      );

      if (apiResponse.success && apiResponse.data != null) {
        return mapSellerProductResponseListToEntities(apiResponse.data!);
      }

      final message = apiResponse.error?.message ?? 'Failed to fetch products';
      throw OrganizationException(message);
    } catch (e) {
      print('[DEBUG] getMyProducts error: $e');
      rethrow;
    }
  }

  @override
  Future<SellerProduct> getMyProductById(int productId) async {
    final token = await _requireToken();
    final apiResponse = await remote.getMyProductById(
      productId: productId,
      token: token,
    );

    if (apiResponse.success && apiResponse.data != null) {
      return mapSellerProductResponseToEntity(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Failed to fetch product';
    throw OrganizationException(message);
  }

  @override
  Future<SellerProduct> createProduct({
    required String name,
    required String description,
    required double price,
    List<String>? tags,
  }) async {
    final token = await _requireToken();
    final request = SellerProductRequest(
      name: name,
      description: description,
      price: price,
      tags: tags,
    );

    final apiResponse = await remote.createProduct(
      productData: request,
      token: token,
    );

    if (apiResponse.success && apiResponse.data != null) {
      return mapSellerProductResponseToEntity(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Failed to create product';
    throw OrganizationException(message);
  }

  @override
  Future<SellerProduct> createProductWithImages({
    required String name,
    required String description,
    required double price,
    required List<Uint8List> imageBytes,
    List<String>? tags,
  }) async {
    final token = await _requireToken();
    final request = SellerProductRequest(
      name: name,
      description: description,
      price: price,
      tags: tags,
    );

    final apiResponse = await remote.createProductWithImages(
      productData: request,
      imageBytes: imageBytes,
      token: token,
    );

    if (apiResponse.success && apiResponse.data != null) {
      return mapSellerProductResponseToEntity(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Failed to create product';
    throw OrganizationException(message);
  }

  @override
  Future<SellerProduct> updateProduct({
    required int productId,
    required String name,
    required String description,
    required double price,
    List<String>? tags,
  }) async {
    final token = await _requireToken();
    final request = SellerProductRequest(
      name: name,
      description: description,
      price: price,
      tags: tags,
    );

    final apiResponse = await remote.updateMyProduct(
      productId: productId,
      productData: request,
      token: token,
    );

    if (apiResponse.success && apiResponse.data != null) {
      return mapSellerProductResponseToEntity(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Failed to update product';
    throw OrganizationException(message);
  }

  @override
  Future<void> softDeleteProduct(int productId) async {
    final token = await _requireToken();
    final apiResponse = await remote.softDeleteProduct(
      productId: productId,
      token: token,
    );

    if (apiResponse.success) return;

    final message = apiResponse.error?.message ?? 'Failed to delete product';
    throw OrganizationException(message);
  }

  @override
  Future<SellerProduct> restoreProduct(int productId) async {
    final token = await _requireToken();
    final apiResponse = await remote.restoreProduct(
      productId: productId,
      token: token,
    );

    if (apiResponse.success && apiResponse.data != null) {
      return mapSellerProductResponseToEntity(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Failed to restore product';
    throw OrganizationException(message);
  }

  @override
  Future<void> uploadProductImages({
    required int productId,
    required List<Uint8List> imageBytes,
  }) async {
    final token = await _requireToken();
    final apiResponse = await remote.uploadProductImages(
      productId: productId,
      imageBytes: imageBytes,
      token: token,
    );

    if (apiResponse.success) return;

    final message = apiResponse.error?.message ?? 'Failed to upload images';
    throw OrganizationException(message);
  }

  @override
  Future<SellerMetrics> getSellerMetrics() async {
    final token = await _requireToken();
    final apiResponse = await remote.getMyMetrics(token: token);

    if (apiResponse.success && apiResponse.data != null) {
      return mapSellerMetricsResponseToEntity(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Failed to fetch metrics';
    throw OrganizationException(message);
  }

  @override
  Future<ProductRating> rateProduct({
    required int productId,
    required int rating,
    String? comment,
  }) async {
    final token = await _requireToken();
    final request = ProductRatingRequest(
      productId: productId,
      rating: rating,
      comment: comment,
    );

    final apiResponse = await remote.rateProduct(
      request: request,
      token: token,
    );

    if (apiResponse.success && apiResponse.data != null) {
      return mapProductRatingResponseToEntity(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Failed to rate product';
    throw OrganizationException(message);
  }

  @override
  Future<void> deleteProductRating(int productId) async {
    final token = await _requireToken();
    final apiResponse = await remote.deleteProductRating(
      productId: productId,
      token: token,
    );

    if (apiResponse.success) return;

    final message = apiResponse.error?.message ?? 'Failed to delete rating';
    throw OrganizationException(message);
  }

  @override
  Future<List<ProductRating>> getProductRatings(int productId) async {
    final apiResponse = await remote.getProductRatings(productId);

    if (apiResponse.success && apiResponse.data != null) {
      return mapProductRatingResponseListToEntities(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Failed to fetch ratings';
    throw OrganizationException(message);
  }

  @override
  Future<List<SellerProduct>> getProductsBySellerId(String sellerId) async {
    final apiResponse = await remote.getProductsBySellerId(sellerId: sellerId);

    if (apiResponse.success && apiResponse.data != null) {
      return mapSellerProductResponseListToEntities(apiResponse.data!);
    }

    final message = apiResponse.error?.message ?? 'Failed to fetch products';
    throw OrganizationException(message);
  }
}
