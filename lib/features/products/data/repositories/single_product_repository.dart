import 'package:flutter_application_1/core/entities/product.dart'
    as domain_entity;

import '../datasources/product_remote_data_source.dart';
import '../mappers/product_mapper.dart';
import '../../domain/repositories/single_product_repository.dart' as domain;

class SingleProductRepositoryImpl implements domain.SingleProductRepository {
  final ProductRemoteDataSource remote;

  SingleProductRepositoryImpl(this.remote);

  @override
  Future<domain_entity.Product?> getProductById(String id) async {
    final model = await remote.fetchProductById(id);
    if (model == null) return null;
    return ProductMapper.toDomain(model);
  }
}
