/// DTO for a product returned in the event products response.
/// Based on backend ProductResponseDto.
class EventProductModel {
  final int id;
  final String name;
  final String? description;
  final double? price;
  final double? rating;
  final int? ratingCount;
  final int? totalSales;
  final int? sellerProfileId;
  final int? sellerUserId;
  final String? sellerFirstName;
  final String? sellerLastName;
  final List<String> tags;
  final List<String> imagePaths;
  final String? categoryName;

  const EventProductModel({
    required this.id,
    required this.name,
    this.description,
    this.price,
    this.rating,
    this.ratingCount,
    this.totalSales,
    this.sellerProfileId,
    this.sellerUserId,
    this.sellerFirstName,
    this.sellerLastName,
    this.tags = const [],
    this.imagePaths = const [],
    this.categoryName,
  });

  factory EventProductModel.fromJson(Map<String, dynamic> json) {
    return EventProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      ratingCount: (json['ratingCount'] as num?)?.toInt(),
      totalSales: (json['totalSales'] as num?)?.toInt(),
      sellerProfileId: (json['sellerProfileId'] as num?)?.toInt(),
      sellerUserId: (json['sellerUserId'] as num?)?.toInt(),
      sellerFirstName: json['sellerFirstName'] as String?,
      sellerLastName: json['sellerLastName'] as String?,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      imagePaths:
          (json['imagePaths'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      categoryName: _extractCategoryName(json['category']),
    );
  }

  static String? _extractCategoryName(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value['name']?.toString();
    }
    return value?.toString();
  }

  /// Primary image URL (first image path if available).
  String? get primaryImageUrl =>
      imagePaths.isNotEmpty ? imagePaths.first : null;

  /// Seller full name.
  String get sellerName {
    final first = sellerFirstName ?? '';
    final last = sellerLastName ?? '';
    return '$first $last'.trim();
  }
}
