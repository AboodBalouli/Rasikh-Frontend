class StoreInfo {
  final String storeName;
  final String description;
  final String sellerDescription;
  final String address;
  final String whatsappPhone;
  final double? averageRating;
  final int? ratingCount;
  final double? latitude;
  final double? longitude;
  final String? profilePictureUrl;
  final String? sellerProfileId;

  const StoreInfo({
    required this.storeName,
    required this.description,
    required this.sellerDescription,
    required this.address,
    required this.whatsappPhone,
    this.averageRating,
    this.ratingCount,
    this.latitude,
    this.longitude,
    this.profilePictureUrl,
    this.sellerProfileId,
  });
}
