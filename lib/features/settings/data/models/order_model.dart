class OrderModel {
  final String id;
  final String customerName;
  final String type;
  final String status;
  final String details;
  final String date;
  final String? phone;
  final String? location;
  final bool isSpecial;
  final String? imagePath;
  final String? price;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.type,
    required this.status,
    required this.details,
    required this.date,
    this.price,
    this.phone,
    this.location,
    this.isSpecial = false,
    this.imagePath,
  });

  OrderModel copyWith({
    String? id,
    String? customerName,
    String? type,
    String? status,
    String? details,
    String? date,
    String? phone,
    String? location,
    bool? isSpecial,
    String? imagePath,
    String? price,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      type: type ?? this.type,
      status: status ?? this.status,
      details: details ?? this.details,
      date: date ?? this.date,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      isSpecial: isSpecial ?? this.isSpecial,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
    );
  }
}
