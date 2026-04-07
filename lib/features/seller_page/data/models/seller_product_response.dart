class SellerProductResponse {
  final String id;
  final String title;
  final String? description;
  final String price;
  final String? imageUrl;
  final String? category;
  final List<String> tags;
  final List<String> imagePaths;

  SellerProductResponse({
    required this.id,
    required this.title,
    required this.price,
    this.description,
    this.imageUrl,
    this.category,
    this.tags = const [],
    this.imagePaths = const [],
  });

  factory SellerProductResponse.fromJson(Map<String, dynamic> json) {
    String? extractCategoryName(dynamic value) {
      if (value is Map<String, dynamic>) {
        return value['name']?.toString();
      }
      return value?.toString();
    }

    List<String> extractImagePaths(Map<String, dynamic> json) {
      final paths = json['imagePaths'];
      if (paths is List && paths.isNotEmpty) {
        return paths.map((e) => e?.toString() ?? '').where((e) => e.isNotEmpty).toList();
      }
      final singleImage = json['image']?.toString() ?? json['imageUrl']?.toString();
      return singleImage != null && singleImage.isNotEmpty ? [singleImage] : [];
    }

    String? extractPrimaryImageUrl(Map<String, dynamic> json) {
      final imagePaths = json['imagePaths'];
      if (imagePaths is List && imagePaths.isNotEmpty) {
        return imagePaths.first?.toString();
      }
      return json['image']?.toString() ?? json['imageUrl']?.toString();
    }

    return SellerProductResponse(
      id: json['id'].toString(),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      description: json['description']?.toString(),
      price: json['price']?.toString() ?? '',
      imageUrl: extractPrimaryImageUrl(json),
      category: extractCategoryName(json['category']),
      tags: json['tags'] is List
          ? List<String>.from(json['tags'])
          : const <String>[],
      imagePaths: extractImagePaths(json),
    );
  }
}
