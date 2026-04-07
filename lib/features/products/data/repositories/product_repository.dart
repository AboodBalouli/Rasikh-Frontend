import 'dart:typed_data';
import '../datasources/product_remote_data_source.dart';
import '../mappers/product_mapper.dart';
import '../models/create_product_request.dart';
import 'package:flutter_application_1/core/entities/product.dart'
    as domain_entity;
import '../../domain/repositories/product_repository.dart' as domain;

class ProductRepositoryImpl implements domain.ProductRepository {
  final ProductRemoteDataSource remote;

  ProductRepositoryImpl(this.remote);

  @override
  Future<List<domain_entity.Product>> getProducts() async {
    final models = await remote.fetchProducts();
    return models.map(ProductMapper.toDomain).toList();
  }

  @override
  Future<List<domain_entity.Product>> getProductsBySellerId(
    String sellerId,
  ) async {
    final models = await remote.fetchProductsBySellerId(sellerId);
    return models.map(ProductMapper.toDomain).toList();
  }

  @override
  Future<domain_entity.Product> createProductWithImages({
    required String name,
    required String description,
    required double price,
    required List<String> tags,
    required List<Uint8List> images,
  }) async {
    final request = CreateProductRequest(
      name: name,
      description: description,
      price: price,
      tags: tags,
    );
    final model = await remote.createProductWithImages(
      request: request,
      images: images,
    );
    return ProductMapper.toDomain(model);
  }
}
