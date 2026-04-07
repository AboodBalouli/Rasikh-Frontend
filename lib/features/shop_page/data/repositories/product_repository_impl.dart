import '../../domain/repositories/product_repository.dart';
import 'package:flutter_application_1/core/network/models/api_response.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource datasource;

  ProductRepositoryImpl(this.datasource);

  @override
  Future<List<Product>> getAllProducts({
    int pageNumber = 0,
    int pageSize = 10,
    String? searchItem,
    bool sortDescending = false,
  }) async {
    final json = await datasource.getAllProducts(
      pageNumber: pageNumber,
      pageSize: pageSize,
      searchItem: searchItem,
      sortDescending: sortDescending,
    );

    final api = ApiResponse<Map<String, dynamic>>.fromJson(
      json,
      (value) => value as Map<String, dynamic>,
    );
    if (api.success != true || api.data == null) {
      throw Exception(api.error?.message ?? 'Failed to fetch products');
    }

    final page = api.data!;
    final itemsRaw = page['data'];
    final items = itemsRaw is List ? itemsRaw : const <Object?>[];

    final models = items
        .whereType<Map<String, dynamic>>()
        .map(ProductModel.fromJson)
        .toList();
    return List<Product>.from(models);
  }
}
