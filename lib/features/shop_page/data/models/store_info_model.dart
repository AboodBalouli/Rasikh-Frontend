import '../../domain/entities/store_info.dart';

class StoreInfoModel extends StoreInfo {
  const StoreInfoModel({
    required super.storeName,
    required super.description,
    required super.sellerDescription,
    required super.address,
    required super.whatsappPhone,
    super.averageRating,
    super.ratingCount,
    super.latitude,
    super.longitude,
  });

  factory StoreInfoModel.fromJson(Map<String, dynamic> json) {
    return StoreInfoModel(
      storeName: (json['storeName'] as String?)?.trim() ?? '',
      description: (json['description'] ?? '') as String,
      sellerDescription: (json['sellerDescription'] ?? '') as String,
      address: (json['address'] ?? '') as String,
      whatsappPhone: (json['whatsappPhone'] ?? '') as String,
      averageRating: json['averageRating'] is num
          ? (json['averageRating'] as num).toDouble()
          : null,
      ratingCount: (json['ratingCount'] as num?)?.toInt(),
      latitude: json['latitude'] is num
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] is num
          ? (json['longitude'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'storeName': storeName,
    'description': description,
    'sellerDescription': sellerDescription,
    'address': address,
    'whatsappPhone': whatsappPhone,
    'averageRating': averageRating,
    'ratingCount': ratingCount,
    'latitude': latitude,
    'longitude': longitude,
  };
}
