class ProductCardModel {
  String id;
  String? imagePath;
  dynamic imageFile;
  String title;
  String price;
  String? discountPrice;
  bool isDiscounted;
  String? description;
  bool hidden;
  List<String>? tags;
  final bool hasBulkDiscount;
  final String? category;
  String originalPrice;
  List<String>? imagePaths;

  ProductCardModel({
    required this.id,
    this.imagePath,
    this.imageFile,
    required this.title,
    required this.price,
    this.discountPrice,
    this.isDiscounted = false,
    this.description,
    this.hidden = false,
    this.tags = const [],
    this.hasBulkDiscount = false,
    this.category,
    required this.originalPrice,
    this.imagePaths,
  });
  
  ProductCardModel copyWith({
    String? id,
    String? imagePath,
    dynamic imageFile,
    String? title,
    String? price,
    String? discountPrice,
    bool? isDiscounted,
    String? description,
    bool? hidden,
    List<String>? tags,
    bool? hasBulkDiscount,
    String? category,
    String? originalPrice,
    List<String>? imagePaths,
  }) {
    return ProductCardModel(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      imageFile: imageFile ?? this.imageFile,
      title: title ?? this.title,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      isDiscounted: isDiscounted ?? this.isDiscounted,
      description: description ?? this.description,
      hidden: hidden ?? this.hidden,
      tags: tags ?? this.tags,
      hasBulkDiscount: hasBulkDiscount ?? this.hasBulkDiscount,
      category: category ?? this.category,
      originalPrice: originalPrice ?? this.originalPrice,
      imagePaths: imagePaths ?? this.imagePaths,
    );
  }
}
