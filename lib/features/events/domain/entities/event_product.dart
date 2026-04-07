/// Domain entity for a product associated with an event via tags.
class EventProduct {
  final int id;
  final String name;
  final String? description;
  final double? price;
  final double? rating;
  final int? ratingCount;
  final int? totalSales;
  final int? sellerProfileId;
  final int? sellerUserId;
  final String sellerName;
  final List<String> tags;
  final List<String> imagePaths;
  final String? categoryName;

  const EventProduct({
    required this.id,
    required this.name,
    this.description,
    this.price,
    this.rating,
    this.ratingCount,
    this.totalSales,
    this.sellerProfileId,
    this.sellerUserId,
    this.sellerName = '',
    this.tags = const [],
    this.imagePaths = const [],
    this.categoryName,
  });

  /// Primary image URL (first image path if available).
  String? get primaryImageUrl =>
      imagePaths.isNotEmpty ? imagePaths.first : null;
}
