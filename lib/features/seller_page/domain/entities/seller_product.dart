class SellerProduct {
  final String id;
  final String title;
  final String price;
  final String? description;
  final String? imageUrl;
  final String? category;
  final List<String> tags;
  final List<String> imagePaths;

  const SellerProduct({
    required this.id,
    required this.title,
    required this.price,
    this.description,
    this.imageUrl,
    this.category,
    this.tags = const [],
    this.imagePaths = const [],
  });
}
