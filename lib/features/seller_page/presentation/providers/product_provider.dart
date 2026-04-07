// features/product/providers/products_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/entities/product_card_model.dart';
import 'package:flutter_application_1/app/dependency_injection/seller_dependency_injection.dart';

// هذا هو المتغير الذي يبحث عنه الكود
final productsProvider =
    AsyncNotifierProvider<ProductsNotifier, List<ProductCardModel>>(() {
      return ProductsNotifier();
    });

class ProductsNotifier extends AsyncNotifier<List<ProductCardModel>> {
  @override
  Future<List<ProductCardModel>> build() async {
    final usecase = ref.read(getMyProductsUseCaseProvider);
    final products = await usecase();

    String resolveImageUrl(String? path) {
      if (path == null || path.trim().isEmpty) return '';
      final trimmed = path.trim();
      if (trimmed.startsWith('http')) return trimmed;
      if (trimmed.startsWith('/')) return '${AppConfig.apiBaseUrl}$trimmed';
      return '${AppConfig.apiBaseUrl}/$trimmed';
    }

    return products
        .map(
          (p) => ProductCardModel(
            id: p.id,
            imagePath: resolveImageUrl(p.imageUrl),
            title: p.title,
            price: p.price,
            originalPrice: p.price,
            description: p.description,
            category: p.category,
            tags: p.tags,
            imagePaths: p.imagePaths.map((path) => resolveImageUrl(path)).toList(),
          ),
        )
        .toList();
  }

  // بقية الدوال (addProduct, deleteProduct...)
}
