import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import '../models/wishlist_product_response.dart';

String _toAbsoluteUrl(String pathOrUrl) {
  final trimmed = pathOrUrl.trim();
  if (trimmed.isEmpty) return '';
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }
  if (trimmed.startsWith('/')) return '${AppConfig.apiBaseUrl}$trimmed';
  return '${AppConfig.apiBaseUrl}/$trimmed';
}

Product mapWishlistProductResponseToProduct(WishlistProductResponse dto) {
  final firstImage = dto.imagePaths.isEmpty ? '' : dto.imagePaths.first;

  return Product(
    id: dto.id,
    name: dto.name,
    description: dto.description,
    price: dto.price,
    imageUrl: firstImage.isEmpty
        ? 'assets/images/cat1.jpg'
        : _toAbsoluteUrl(firstImage),
    sellerId: '',
    category: dto.category?.name ?? '',
    rating: dto.rating,
    reviewCount: 0,
  );
}
