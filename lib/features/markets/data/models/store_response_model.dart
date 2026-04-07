class StoreResponseModel {
  final int profileId;
  final int userId;
  final String sellerName;
  final String? profilePictureUrl;
  final SellerCategoryModel? sellerCategory;
  final StoreInfoModel? store;
  final String? country;
  final String? government;

  const StoreResponseModel({
    required this.profileId,
    required this.userId,
    required this.sellerName,
    this.profilePictureUrl,
    this.sellerCategory,
    this.store,
    this.country,
    this.government,
  });

  factory StoreResponseModel.fromJson(Map<String, dynamic> json) {
    return StoreResponseModel(
      profileId: (json['profileId'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      sellerName: (json['sellerName'] as String?)?.trim() ?? '',
      profilePictureUrl: json['profilePictureUrl'] as String?,
      sellerCategory: json['sellerCategory'] is Map<String, dynamic>
          ? SellerCategoryModel.fromJson(
              json['sellerCategory'] as Map<String, dynamic>,
            )
          : null,
      store: json['store'] is Map<String, dynamic>
          ? StoreInfoModel.fromJson(json['store'] as Map<String, dynamic>)
          : null,
      country: json['country'] as String?,
      government: json['government'] as String?,
    );
  }
}

class SellerCategoryModel {
  final int id;
  final String name;

  const SellerCategoryModel({required this.id, required this.name});

  factory SellerCategoryModel.fromJson(Map<String, dynamic> json) {
    return SellerCategoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?)?.trim() ?? '',
    );
  }
}

class StoreInfoModel {
  final String? address;
  final String? phone;
  final String? workingHours;
  final int? totalSales;
  final String? storeName;
  final String? storeDescription;
  final double? averageRating;
  final int? ratingCount;
  final String? themeColor;
  final String? country;
  final String? government;
  final List<String>? tags;

  const StoreInfoModel({
    this.address,
    this.phone,
    this.workingHours,
    this.totalSales,
    this.storeName,
    this.storeDescription,
    this.averageRating,
    this.ratingCount,
    this.themeColor,
    this.country,
    this.government,
    this.tags,
  });

  factory StoreInfoModel.fromJson(Map<String, dynamic> json) {
    return StoreInfoModel(
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      workingHours: json['workingHours'] as String?,
      totalSales: (json['totalSales'] as num?)?.toInt(),
      storeName: (json['storeName'] as String?)?.trim(),
      storeDescription: (json['storeDescription'] as String?)?.trim(),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      ratingCount: (json['ratingCount'] as num?)?.toInt(),
      country: (json['country'] as String?)?.trim(),
      government: (json['government'] as String?)?.trim(),
      themeColor: (json['themeColor'] as String?)?.trim(),
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}
