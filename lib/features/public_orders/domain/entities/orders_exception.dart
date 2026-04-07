class OrdersException implements Exception {
  final String message;

  const OrdersException(this.message);

  @override
  String toString() => 'OrdersException: $message';
}
