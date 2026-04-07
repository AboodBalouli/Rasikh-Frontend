import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/products/data/datasources/product_remote_data_source.dart';
import 'package:flutter_application_1/features/products/data/repositories/product_repository.dart'
    as data_impl;
import 'package:flutter_application_1/features/products/domain/repositories/product_repository.dart'
    as domain;
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/app/dependency_injection/riverpod_providers.dart'
    as di;
import 'package:flutter_application_1/features/products/domain/usecases/get_products_by_seller_id_usecase.dart';

/// ApiService provider - single instance across app
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((
  ref,
) {
  final api = ref.read(di.apiServiceProvider);
  final tokenProvider = ref.read(di.tokenProvider);
  return ProductRemoteDataSource(api, tokenProvider: tokenProvider);
});

final productRepositoryProvider = Provider<domain.ProductRepository>((ref) {
  final remote = ref.read(productRemoteDataSourceProvider);
  return data_impl.ProductRepositoryImpl(remote);
});

final getProductsBySellerIdUsecaseProvider =
    Provider<GetProductsBySellerIdUsecase>((ref) {
      final repo = ref.read(productRepositoryProvider);
      return GetProductsBySellerIdUsecase(repo);
    });

/// FutureProvider that fetches products from repository
final productsFutureProvider = FutureProvider.autoDispose<List<Product>>((
  ref,
) async {
  final repo = ref.read(productRepositoryProvider);
  return repo.getProducts();
});

/// Fetch products for a store/seller profile.
final productsBySellerIdProvider = FutureProvider.autoDispose
    .family<List<Product>, String>((ref, sellerId) {
      final usecase = ref.read(getProductsBySellerIdUsecaseProvider);
      return usecase(sellerId);
    });
