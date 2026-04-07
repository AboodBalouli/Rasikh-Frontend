import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/products/presentation/providers/product_providers.dart'
    as products;

/// Products for a specific store/seller profile.
/// Backend: GET /api/product/sellers-products/{sellerId}
final storeProductsProvider = FutureProvider.family<List<Product>, String>((
  ref,
  sellerId,
) async {
  final repo = ref.read(products.productRepositoryProvider);
  return repo.getProductsBySellerId(sellerId);
});
