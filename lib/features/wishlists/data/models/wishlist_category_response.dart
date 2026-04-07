class WishlistCategoryResponse {
  final String name;
  final String description;

  const WishlistCategoryResponse({
    required this.name,
    required this.description,
  });

  factory WishlistCategoryResponse.fromJson(Map<String, dynamic> json) {
    return WishlistCategoryResponse(
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}
