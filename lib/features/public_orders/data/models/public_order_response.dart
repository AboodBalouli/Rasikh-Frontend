class PublicOrderResponse {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String? imageUrl;
  final String customerFirstName;
  final String customerLastName;
  final String location;
  final String phoneNumber;
  final String whatsappUrl;
  final String status;
  final String createdAt;
  final String? updatedAt;

  PublicOrderResponse({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.customerFirstName,
    required this.customerLastName,
    required this.location,
    required this.phoneNumber,
    required this.whatsappUrl,
    required this.status,
    required this.createdAt,
    this.imageUrl,
    this.updatedAt,
  });

  factory PublicOrderResponse.fromJson(Map<String, dynamic> json) {
    return PublicOrderResponse(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['imageUrl'] as String?,
      customerFirstName: json['customerFirstName']?.toString() ?? '',
      customerLastName: json['customerLastName']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      whatsappUrl: json['whatsappUrl']?.toString() ?? '',
      status: json['status']?.toString() ?? 'DISPLAYED',
      createdAt: json['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
      updatedAt: json['updatedAt'] as String?,
    );
  }
}
