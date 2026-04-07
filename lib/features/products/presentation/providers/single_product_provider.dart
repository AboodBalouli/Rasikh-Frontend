import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/products/data/repositories/single_product_repository.dart';
import 'package:flutter_application_1/features/products/domain/repositories/single_product_repository.dart'
    as domain;
import 'package:flutter_application_1/features/products/presentation/providers/product_providers.dart'
    show productRemoteDataSourceProvider;

final singleProductRepositoryProvider =
    Provider<domain.SingleProductRepository>((ref) {
      final remote = ref.read(productRemoteDataSourceProvider);
      return SingleProductRepositoryImpl(remote);
    });

final singleProductFutureProvider = FutureProvider.family<Product?, String>((
  ref,
  id,
) async {
  final repo = ref.read(singleProductRepositoryProvider);
  return repo.getProductById(id);
});
