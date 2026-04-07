import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.sellerId,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.category,
    super.isCustomizable,
    required super.rating,
    required super.reviewCount,
  });

  // form json : to object
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final imageUrl = _extractPrimaryImageUrl(json);

    return ProductModel(
      id: json['id']?.toString() ?? '',
      sellerId: (json['sellerProfileId'] ?? json['sellerId'])?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: imageUrl,
      category: _extractCategoryName(json),
      isCustomizable: json['isCustomizable'] == true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      // The Product API doesn't expose a reviewCount; use totalSales as a
      // reasonable fallback to keep the existing UI stable.
      reviewCount: (json['totalSales'] as int?) ?? (json['reviewCount'] ?? 0),
    );
  }

  static String _extractCategoryName(Map<String, dynamic> json) {
    final category = json['category'];
    if (category is Map<String, dynamic>) {
      return category['name']?.toString() ?? '';
    }
    return category?.toString() ?? '';
  }

  static String _extractPrimaryImageUrl(Map<String, dynamic> json) {
    final imagePaths = json['imagePaths'];

    String? path;
    if (imagePaths is List && imagePaths.isNotEmpty) {
      path = imagePaths.first?.toString();
    } else {
      path = json['imageUrl']?.toString();
    }

    final trimmed = path?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      // Keep a working fallback for existing UI.
      return 'assets/images/cat1.jpg';
    }

    final uri = Uri.tryParse(trimmed);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return trimmed;
    }

    if (trimmed.startsWith('/')) return '${AppConfig.apiBaseUrl}$trimmed';
    return '${AppConfig.apiBaseUrl}/$trimmed';
  }

  // to json : object to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sellerId': sellerId,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isCustomizable': isCustomizable,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    // Keep consistent with Product (id-based equality) so lists/maps work
    // when products originate from different endpoints.
    return other is Product && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
