class SellerCategoryModel {
  final int id;
  final String name;

  const SellerCategoryModel({required this.id, required this.name});

  factory SellerCategoryModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final id = rawId is int
        ? rawId
        : rawId is num
        ? rawId.toInt()
        : int.tryParse(rawId.toString()) ?? 0;

    return SellerCategoryModel(id: id, name: json['name']?.toString() ?? '');
  }
}
