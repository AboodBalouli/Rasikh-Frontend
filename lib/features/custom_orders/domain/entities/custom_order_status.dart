/// Status enum for custom order requests.
enum CustomOrderStatus {
  pending,
  quoted,
  accepted,
  rejected,
  canceled;

  /// Parse status from API string.
  static CustomOrderStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return CustomOrderStatus.pending;
      case 'QUOTED':
        return CustomOrderStatus.quoted;
      case 'ACCEPTED':
        return CustomOrderStatus.accepted;
      case 'REJECTED':
        return CustomOrderStatus.rejected;
      case 'CANCELED':
        return CustomOrderStatus.canceled;
      default:
        return CustomOrderStatus.pending;
    }
  }

  /// Convert to API string.
  String toApiString() => name.toUpperCase();

  /// Display name in Arabic.
  String get displayNameAr {
    switch (this) {
      case CustomOrderStatus.pending:
        return 'قيد الانتظار';
      case CustomOrderStatus.quoted:
        return 'تم التسعير';
      case CustomOrderStatus.accepted:
        return 'مقبول';
      case CustomOrderStatus.rejected:
        return 'مرفوض';
      case CustomOrderStatus.canceled:
        return 'ملغي';
    }
  }

  /// Whether the order can be modified.
  bool get canModify => this == CustomOrderStatus.pending;

  /// Whether seller can quote this order.
  bool get canQuote => this == CustomOrderStatus.pending;

  /// Whether the order is in a final state.
  bool get isFinal =>
      this == CustomOrderStatus.accepted ||
      this == CustomOrderStatus.rejected ||
      this == CustomOrderStatus.canceled;
}
