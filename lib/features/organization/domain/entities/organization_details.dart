class OrganizationDetails {
  final int id;
  final String name;
  final String description;
  final int ownerProfileId;
  final int? ownerUserId; // Added for profile picture upload
  final String status;
  final String? ownerProfileImageUrl;
  final String? storeCountry;
  final String? storeGovernment;
  final String? storePhone;
  final double? averageRating;
  final int? ratingCount;

  const OrganizationDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerProfileId,
    this.ownerUserId,
    required this.status,
    this.ownerProfileImageUrl,
    this.storeCountry,
    this.storeGovernment,
    this.storePhone,
    this.averageRating,
    this.ratingCount,
  });

  bool get isApproved => status.toUpperCase() == 'APPROVED';
}
