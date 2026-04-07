/// Domain entity representing a seller's product for admin management
class SellerProduct {
  final int id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int ratingCount;
  final String? categoryName;
  final List<String> imagePaths;
  final List<String> tags;
  final int totalSales;
  final int sellerProfileId;
  final bool isVisible; // true = active, false = soft-deleted/hidden

  const SellerProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.ratingCount,
    this.categoryName,
    required this.imagePaths,
    required this.tags,
    required this.totalSales,
    required this.sellerProfileId,
    this.isVisible = true,
  });

  /// Returns the primary image URL or empty string
  String get primaryImageUrl {
    if (imagePaths.isEmpty) return '';
    return imagePaths.first;
  }

  SellerProduct copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    double? rating,
    int? ratingCount,
    String? categoryName,
    List<String>? imagePaths,
    List<String>? tags,
    int? totalSales,
    int? sellerProfileId,
    bool? isVisible,
  }) {
    return SellerProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      categoryName: categoryName ?? this.categoryName,
      imagePaths: imagePaths ?? this.imagePaths,
      tags: tags ?? this.tags,
      totalSales: totalSales ?? this.totalSales,
      sellerProfileId: sellerProfileId ?? this.sellerProfileId,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}
