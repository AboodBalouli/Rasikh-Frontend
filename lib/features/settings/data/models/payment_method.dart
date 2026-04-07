class PaymentMethod {
  final String id;
  final String title;
  final String subtitle;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.title,
    required this.subtitle,
    this.isDefault = false,
  });

  PaymentMethod copyWith({bool? isDefault}) {
    return PaymentMethod(
      id: id,
      title: title,
      subtitle: subtitle,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
