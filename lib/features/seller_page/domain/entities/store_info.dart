class StoreInfo {
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

  const StoreInfo({
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
}
