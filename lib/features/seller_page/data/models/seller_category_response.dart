class SellerCategoryResponse {
  final int id;
  final String name;

  SellerCategoryResponse({required this.id, required this.name});

  factory SellerCategoryResponse.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    return SellerCategoryResponse(
      id: id is num ? id.toInt() : int.tryParse(id?.toString() ?? '') ?? 0,
      name: (json['name'] ?? '').toString(),
    );
  }
}
