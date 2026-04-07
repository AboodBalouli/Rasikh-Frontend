import 'wishlist_category_response.dart';

class WishlistProductResponse {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final WishlistCategoryResponse? category;
  final List<String> imagePaths;

  const WishlistProductResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.category,
    required this.imagePaths,
  });

  factory WishlistProductResponse.fromJson(Map<String, dynamic> json) {
    final rawPaths = json['imagePaths'];
    final paths = rawPaths is List
        ? rawPaths.map((e) => e.toString()).toList()
        : const <String>[];

    return WishlistProductResponse(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] is Map<String, dynamic>
          ? WishlistCategoryResponse.fromJson(
              (json['category'] as Map).cast<String, dynamic>(),
            )
          : null,
      imagePaths: paths,
    );
  }
}
