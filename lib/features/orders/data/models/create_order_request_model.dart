class CreateOrderRequestModel {
  final String shippingAddress;
  final String phoneNumber;
  final String? notes;

  const CreateOrderRequestModel({
    required this.shippingAddress,
    required this.phoneNumber,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'shippingAddress': shippingAddress,
      'phoneNumber': phoneNumber,
      if (notes != null) 'notes': notes,
    };
  }
}
