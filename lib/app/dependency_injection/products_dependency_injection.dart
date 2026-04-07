import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_1/app/dependency_injection/riverpod_providers.dart'
    as di;
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/products/data/datasources/product_remote_data_source.dart';
import 'package:flutter_application_1/features/products/data/repositories/product_repository.dart'
    as data_impl;
import 'package:flutter_application_1/features/products/domain/usecases/get_products_by_seller_id_usecase.dart';
import 'package:flutter_application_1/features/products/domain/usecases/create_product_usecase.dart';

/// App-level provider to fetch products by seller/org id.
/// Keeps feature wiring in the app layer to avoid feature-to-feature dependencies.
final getProductsBySellerIdProvider =
    Provider<Future<List<Product>> Function(String sellerId)>((ref) {
      final api = ref.read(di.apiServiceProvider);
      final tokenProvider = ref.read(di.tokenProvider);
      final remote = ProductRemoteDataSource(api, tokenProvider: tokenProvider);
      final repo = data_impl.ProductRepositoryImpl(remote);
      final usecase = GetProductsBySellerIdUsecase(repo);
      return (sellerId) => usecase(sellerId);
    });

/// Provider for creating a product with images.
final createProductUseCaseProvider = Provider<CreateProductUseCase>((ref) {
  final api = ref.read(di.apiServiceProvider);
  final tokenProvider = ref.read(di.tokenProvider);
  final remote = ProductRemoteDataSource(api, tokenProvider: tokenProvider);
  final repo = data_impl.ProductRepositoryImpl(remote);
  return CreateProductUseCase(repo);
});

/// Convenience provider for creating a product with images.
final createProductWithImagesProvider =
    Provider<
      Future<Product> Function({
        required String name,
        required String description,
        required double price,
        required List<String> tags,
        required List<Uint8List> images,
      })
    >((ref) {
      final useCase = ref.read(createProductUseCaseProvider);
      return ({
        required String name,
        required String description,
        required double price,
        required List<String> tags,
        required List<Uint8List> images,
      }) => useCase(
        name: name,
        description: description,
        price: price,
        tags: tags,
        images: images,
      );
    });
