/// Response model for product data from the backend
/// Based on ProductResponseDto from product.md
class SellerProductResponse {
  final int id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int ratingCount;
  final CategoryResponse? category;
  final List<String> imagePaths;
  final List<String> tags;
  final int totalSales;
  final int sellerProfileId;
  final int sellerUserId;
  final String sellerFirstName;
  final String sellerLastName;
  final String sellerEmail;
  final String? sellerOverview;
  final bool isDeleted;

  const SellerProductResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.ratingCount,
    this.category,
    required this.imagePaths,
    required this.tags,
    required this.totalSales,
    required this.sellerProfileId,
    required this.sellerUserId,
    required this.sellerFirstName,
    required this.sellerLastName,
    required this.sellerEmail,
    this.sellerOverview,
    this.isDeleted = false,
  });

  factory SellerProductResponse.fromJson(Map<String, dynamic> json) {
    return SellerProductResponse(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : 0.0,
      ratingCount: (json['ratingCount'] ?? 0) as int,
      category: json['category'] != null
          ? CategoryResponse.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      imagePaths:
          (json['imagePaths'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      totalSales: (json['totalSales'] ?? 0) as int,
      sellerProfileId: (json['sellerProfileId'] ?? 0) as int,
      sellerUserId: (json['sellerUserId'] ?? 0) as int,
      sellerFirstName: (json['sellerFirstName'] ?? '') as String,
      sellerLastName: (json['sellerLastName'] ?? '') as String,
      sellerEmail: (json['sellerEmail'] ?? '') as String,
      sellerOverview: json['sellerOverview'] as String?,
      isDeleted: (json['deleted'] ?? json['isDeleted'] ?? false) as bool,
    );
  }
}

class CategoryResponse {
  final String name;
  final String? description;

  const CategoryResponse({required this.name, this.description});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      name: (json['name'] ?? '') as String,
      description: json['description'] as String?,
    );
  }
}
