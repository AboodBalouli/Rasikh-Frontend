/// Request model for creating/updating a product
/// POST /api/product/create, PUT /api/product/my/{id}/update
class SellerProductRequest {
  final String name;
  final String description;
  final double price;
  final List<String>? tags;

  const SellerProductRequest({
    required this.name,
    required this.description,
    required this.price,
    this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      if (tags != null) 'tags': tags,
    };
  }
}
