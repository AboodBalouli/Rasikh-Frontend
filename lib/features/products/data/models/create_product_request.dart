/// Request model for creating a product with the backend.
class CreateProductRequest {
  final String name;
  final String description;
  final double price;
  final List<String> tags;

  const CreateProductRequest({
    required this.name,
    required this.description,
    required this.price,
    required this.tags,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'tags': tags,
  };
}
