/// Model representing a product in the admin dashboard.
class AdminProduct {
  const AdminProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.isVisible,
  });

  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final bool isVisible;

  AdminProduct copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
    bool? isVisible,
  }) {
    return AdminProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}
