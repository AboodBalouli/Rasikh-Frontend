class ProductModel {
  final String id;
  final String title;
  final String? description;
  final String price;
  final String? imageUrl;
  final List<String> imageUrls; // All image URLs from imagePaths
  final String? sellerId;
  final String? category;
  final bool? isCustomizable;
  final double? rating;
  final int? reviewCount;
  final List<String> imagePaths;

  ProductModel({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    this.imageUrl,
    this.imageUrls = const [],
    this.sellerId,
    this.category,
    this.isCustomizable,
    this.rating,
    this.reviewCount,
    this.imagePaths = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    String? extractCategoryName(dynamic value) {
      if (value is Map<String, dynamic>) {
        return value['name']?.toString();
      }
      return value?.toString();
    }

    // Extract all image paths as a list
    List<String> extractAllImageUrls(Map<String, dynamic> json) {
      final imagePaths = json['imagePaths'];
      if (imagePaths is List && imagePaths.isNotEmpty) {
        return imagePaths
            .where((e) => e != null)
            .map((e) => e.toString())
            .toList();
      }
      // Fallback to single image if available
      final singleImage =
          json['image']?.toString() ?? json['imageUrl']?.toString();
      if (singleImage != null && singleImage.isNotEmpty) {
        return [singleImage];
      }
      return [];
    }

    String? extractPrimaryImageUrl(Map<String, dynamic> json) {
      final imagePaths = json['imagePaths'];
      if (imagePaths is List && imagePaths.isNotEmpty) {
        return imagePaths.first?.toString();
      }
      return json['image']?.toString() ?? json['imageUrl']?.toString();
    }

    return ProductModel(
      id: json['id'].toString(),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      description: json['description']?.toString(),
      price: json['price']?.toString() ?? '',
      imageUrl: extractPrimaryImageUrl(json),
      imageUrls: extractAllImageUrls(json),
      sellerId:
          (json['sellerProfileId'] ??
                  json['sellerId'] ??
                  json['seller_id'] ??
                  json['seller'] ??
                  '')
              .toString(),
      category: extractCategoryName(json['category']),
      isCustomizable: json['isCustomizable'] is bool
          ? json['isCustomizable'] as bool
          : (json['is_customizable'] is bool
                ? json['is_customizable'] as bool
                : null),
      rating: json['rating'] is num ? (json['rating'] as num).toDouble() : null,
      reviewCount: json['reviewCount'] is num
          ? (json['reviewCount'] as num).toInt()
          : (json['review_count'] is num
                ? (json['review_count'] as num).toInt()
                : null),
      imagePaths: _extractImagePaths(json),
    );
  }

  /// Helper function to extract image paths from JSON
  static List<String> _extractImagePaths(Map<String, dynamic> json) {
    final imagePaths = json['imagePaths'];
    if (imagePaths is List && imagePaths.isNotEmpty) {
      return imagePaths
          .where((e) => e != null)
          .map((e) => e.toString())
          .toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'image': imageUrl,
      'sellerId': sellerId,
      'category': category,
      'isCustomizable': isCustomizable,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}
