/// Request DTO for creating a custom order.
class CustomOrderRequest {
  final int sellerProfileId;
  final String title;
  final String description;
  final String location;
  final String phoneNumber;
  final String whatsappUrl;

  const CustomOrderRequest({
    required this.sellerProfileId,
    required this.title,
    required this.description,
    required this.location,
    required this.phoneNumber,
    required this.whatsappUrl,
  });

  Map<String, dynamic> toJson() => {
    'sellerProfileId': sellerProfileId,
    'title': title,
    'description': description,
    'location': location,
    'phoneNumber': phoneNumber,
    'whatsappUrl': whatsappUrl,
  };
}

/// Request DTO for updating a custom order.
class CustomOrderUpdateRequest {
  final String? title;
  final String? description;
  final String? location;

  const CustomOrderUpdateRequest({this.title, this.description, this.location});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (title != null) map['title'] = title;
    if (description != null) map['description'] = description;
    if (location != null) map['location'] = location;
    return map;
  }
}

/// Request DTO for quoting a custom order.
class CustomOrderQuoteRequest {
  final double quotedPrice;
  final int estimatedDays;
  final String? sellerNote;

  const CustomOrderQuoteRequest({
    required this.quotedPrice,
    required this.estimatedDays,
    this.sellerNote,
  });

  Map<String, dynamic> toJson() => {
    'quotedPrice': quotedPrice,
    'estimatedDays': estimatedDays,
    if (sellerNote != null) 'sellerNote': sellerNote,
  };
}
