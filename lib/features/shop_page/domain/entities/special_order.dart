class SpecialOrder {
  final String id;
  final String name;
  final String? imagePath;
  final String description;
  final String phoneNumber;
  final String location;
  final DateTime createdAt;
  final bool isAccepted;

  SpecialOrder({
    required this.id,
    required this.name,
    this.imagePath,
    required this.description,
    required this.phoneNumber,
    required this.location,
    required this.createdAt,
    this.isAccepted = false,
  });
}
