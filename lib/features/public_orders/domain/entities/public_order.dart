class PublicOrder {
  final String id;
  final String userId;
  final String customerFirstName;
  final String customerLastName;
  final String title;
  final String description;
  final String? imageUrl;
  final String location;
  final String phoneNumber;
  final String whatsappUrl;
  final String status;
  final DateTime orderDate;
  final DateTime? updatedAt;

  PublicOrder({
    required this.id,
    required this.userId,
    required this.customerFirstName,
    required this.customerLastName,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.location,
    required this.phoneNumber,
    required this.whatsappUrl,
    required this.status,
    required this.orderDate,
    this.updatedAt,
  });

  /// Convenience factory for creating a new public order from form fields.
  ///
  /// Server-owned fields like `id`, `userId`, and customer names are left empty
  /// because they are typically assigned by the backend.
  factory PublicOrder.create({
    required String title,
    required String description,
    String? imageUrl,
    required String location,
    required String phoneNumber,
    required String whatsappUrl,
    String status = 'DISPLAYED',
    DateTime? orderDate,
  }) {
    return PublicOrder(
      id: '',
      userId: '',
      customerFirstName: '',
      customerLastName: '',
      title: title,
      description: description,
      imageUrl: imageUrl,
      location: location,
      phoneNumber: phoneNumber,
      whatsappUrl: whatsappUrl,
      status: status,
      orderDate: orderDate ?? DateTime.now(),
      updatedAt: null,
    );
  }
}
