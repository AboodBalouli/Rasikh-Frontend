class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl; // Primary/first image (backwards compatible)
  final List<String> imageUrls; // All images
  final String sellerId;
  final String category;
  final bool isCustomizable;
  final double rating;
  final int reviewCount;
  final List<String> imagePaths;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.imageUrls = const [],
    required this.sellerId,
    required this.category,
    this.isCustomizable = false,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.imagePaths = const [],
  });

  /// Returns all image URLs, including the primary imageUrl if not in the list
  List<String> get allImageUrls {
    if (imageUrls.isEmpty && imageUrl.isNotEmpty) {
      return [imageUrl];
    }
    return imageUrls;
  }

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
