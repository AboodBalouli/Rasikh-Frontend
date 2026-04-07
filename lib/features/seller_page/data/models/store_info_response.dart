class StoreInfoResponse {
  final String? address;
  final String? phone;
  final String? workingHours;
  final int? totalSales;
  final String? storeName;
  final String? storeDescription;
  final double? averageRating;
  final int? ratingCount;
  final String? country;
  final String? government;
  final String? themeColor;
  final List<String> tags;

  StoreInfoResponse({
    this.address,
    this.phone,
    this.workingHours,
    this.totalSales,
    this.storeName,
    this.storeDescription,
    this.averageRating,
    this.ratingCount,
    this.country,
    this.government,
    this.themeColor,
    this.tags = const [],
  });

  factory StoreInfoResponse.fromJson(Map<String, dynamic> json) {
    double? readDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    int? readInt(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString());
    }

    return StoreInfoResponse(
      address: json['address']?.toString(),
      phone: (json['phone'] ?? json['phoneNumber'])?.toString(),
      workingHours: json['workingHours']?.toString(),
      totalSales: readInt(json['totalSales']),
      storeName: json['storeName']?.toString(),
      storeDescription: json['storeDescription']?.toString(),
      averageRating: readDouble(json['averageRating']),
      ratingCount: readInt(json['ratingCount']),
      country: json['country']?.toString(),
      government: json['government']?.toString(),
      themeColor: json['themeColor']?.toString(),
      tags: json['tags'] is List
          ? List<String>.from(json['tags'])
          : const <String>[],
    );
  }
}
