class PublicOrderUpdateRequest {
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? location;
  final String? phoneNumber;
  final String? whatsappUrl;

  const PublicOrderUpdateRequest({
    this.title,
    this.description,
    this.imageUrl,
    this.location,
    this.phoneNumber,
    this.whatsappUrl,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (title != null) map['title'] = title;
    if (description != null) map['description'] = description;
    if (imageUrl != null) map['imageUrl'] = imageUrl;
    if (location != null) map['location'] = location;
    if (phoneNumber != null) map['phoneNumber'] = phoneNumber;
    if (whatsappUrl != null) map['whatsappUrl'] = whatsappUrl;
    return map;
  }
}
