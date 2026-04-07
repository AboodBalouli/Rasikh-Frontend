class SeasonStore {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<SeasonProduct> products;

  SeasonStore({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.products,
  });
}

class SeasonProduct {
  final String id;
  final String name;
  final String imageUrl;

  SeasonProduct({required this.id, required this.name, required this.imageUrl});
}
