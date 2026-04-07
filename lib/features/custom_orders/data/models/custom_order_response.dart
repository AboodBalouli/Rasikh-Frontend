/// Response DTO for custom order from API.
class CustomOrderResponse {
  final int id;
  final int? customerId;
  final String? customerFirstName;
  final String? customerLastName;
  final int sellerProfileId;
  final String? sellerStoreName;
  final String title;
  final String description;
  final String? location;
  final String? phoneNumber;
  final String? whatsappUrl;
  final String status;
  final List<CustomOrderImageResponse> images;
  final double? quotedPrice;
  final int? estimatedDays;
  final String? sellerNote;
  final String? createdAt;
  final String? updatedAt;

  const CustomOrderResponse({
    required this.id,
    this.customerId,
    this.customerFirstName,
    this.customerLastName,
    required this.sellerProfileId,
    this.sellerStoreName,
    required this.title,
    required this.description,
    this.location,
    this.phoneNumber,
    this.whatsappUrl,
    required this.status,
    this.images = const [],
    this.quotedPrice,
    this.estimatedDays,
    this.sellerNote,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomOrderResponse.fromJson(Map<String, dynamic> json) {
    return CustomOrderResponse(
      id: json['id'] as int,
      customerId: json['customerId'] as int?,
      customerFirstName: json['customerFirstName'] as String?,
      customerLastName: json['customerLastName'] as String?,
      sellerProfileId: json['sellerProfileId'] as int,
      sellerStoreName: json['sellerStoreName'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      location: json['location'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      whatsappUrl: json['whatsappUrl'] as String?,
      status: json['status'] as String? ?? 'PENDING',
      images:
          (json['images'] as List<dynamic>?)
              ?.map(
                (e) => CustomOrderImageResponse.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      quotedPrice: (json['quotedPrice'] as num?)?.toDouble(),
      estimatedDays: json['estimatedDays'] as int?,
      sellerNote: json['sellerNote'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}

/// Response DTO for custom order image.
class CustomOrderImageResponse {
  final int id;
  final String path;
  final String? fileName;

  const CustomOrderImageResponse({
    required this.id,
    required this.path,
    this.fileName,
  });

  factory CustomOrderImageResponse.fromJson(Map<String, dynamic> json) {
    return CustomOrderImageResponse(
      id: json['id'] as int,
      path: json['path'] as String? ?? '',
      fileName: json['fileName'] as String?,
    );
  }
}
