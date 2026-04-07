class PublicOrderRequest {
  final String title;
  final String description;
  final String? imageUrl;
  final String location;
  final String phoneNumber;
  final String whatsappUrl;

  PublicOrderRequest({
    required this.title,
    required this.description,
    this.imageUrl,
    required this.location,
    required this.phoneNumber,
    required this.whatsappUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'location': location,
      'phoneNumber': phoneNumber,
      'whatsappUrl': whatsappUrl,
    };
  }
}
