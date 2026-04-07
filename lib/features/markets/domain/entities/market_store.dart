class MarketStore {
  final int profileId;
  final int userId;
  final String sellerName;
  final String? storeName;
  final String? storeDescription;
  final String? profilePictureUrl;
  final String? categoryName;
  final int? categoryId;
  final String? address;
  final String? phone;
  final String? workingHours;
  final int? totalSales;
  final double? averageRating;
  final int? ratingCount;
  final String? country;
  final String? government;
  final String? themeColor;
  final List<String> tags;

  const MarketStore({
    required this.profileId,
    required this.userId,
    required this.sellerName,
    this.storeName,
    this.storeDescription,
    this.profilePictureUrl,
    this.categoryName,
    this.categoryId,
    this.address,
    this.phone,
    this.workingHours,
    this.totalSales,
    this.averageRating,
    this.ratingCount,
    this.country,
    this.government,
    this.themeColor,
    this.tags = const [],
  });
}
