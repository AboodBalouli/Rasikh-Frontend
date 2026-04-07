import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/shop_page/presentation/pages/product_detail_page.dart';

class ProductDetailRoutePage extends StatelessWidget {
  final String productId;

  const ProductDetailRoutePage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final product = getProductById(productId);

    return ProductDetailPage(
      product: product,
      isFavorite: false,
      onFavoriteToggle: () {},
      scrollController: ScrollController(),
    );
  }

  getProductById(String productId) {}
}
