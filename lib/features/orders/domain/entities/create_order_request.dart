class CreateOrderRequest {
  final String shippingAddress;
  final String phoneNumber;
  final String? notes;

  const CreateOrderRequest({
    required this.shippingAddress,
    required this.phoneNumber,
    this.notes,
  });
}
