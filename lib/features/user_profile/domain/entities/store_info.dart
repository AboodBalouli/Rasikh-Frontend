class StoreInfo {
  final String? address;
  final String? phone;
  final String? workingHours;
  final int? totalSales;

  // Store fields
  final String? storeName;
  final String? description;
  final double? averageRating;
  final int? ratingCount;
  final String? country;
  final String? government;
  final String? themeColor;
  final List<String>? tags;

  // Profile fields that are updated via /profile/me/store
  final String? firstName;
  final String? lastName;

  StoreInfo({
    this.address,
    this.phone,
    this.workingHours,
    this.totalSales,
    this.storeName,
    this.description,
    this.averageRating,
    this.ratingCount,
    this.country,
    this.government,
    this.themeColor,
    this.tags,
    this.firstName,
    this.lastName,
  });
}