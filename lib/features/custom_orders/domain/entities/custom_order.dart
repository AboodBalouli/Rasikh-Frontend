import 'custom_order_status.dart';

/// Domain entity representing a custom order request.
class CustomOrder {
  final String id;
  final String customerId;
  final String customerFirstName;
  final String customerLastName;
  final String sellerProfileId;
  final String? sellerStoreName;
  final String title;
  final String description;
  final String location;
  final String phoneNumber;
  final String whatsappUrl;
  final CustomOrderStatus status;
  final List<String> imageUrls;

  // Quote fields (set by seller)
  final double? quotedPrice;
  final int? estimatedDays;
  final String? sellerNote;

  final DateTime createdAt;
  final DateTime? updatedAt;

  const CustomOrder({
    required this.id,
    required this.customerId,
    required this.customerFirstName,
    required this.customerLastName,
    required this.sellerProfileId,
    this.sellerStoreName,
    required this.title,
    required this.description,
    required this.location,
    required this.phoneNumber,
    required this.whatsappUrl,
    required this.status,
    this.imageUrls = const [],
    this.quotedPrice,
    this.estimatedDays,
    this.sellerNote,
    required this.createdAt,
    this.updatedAt,
  });

  /// Customer's full name.
  String get customerFullName => '$customerFirstName $customerLastName'.trim();

  /// Check if order can be updated by customer.
  bool get canUpdate => status.canModify;

  /// Check if quote can be accepted.
  bool get canAcceptQuote => status == CustomOrderStatus.quoted;

  /// Check if order can be canceled by customer.
  bool get canCancel =>
      status == CustomOrderStatus.pending || status == CustomOrderStatus.quoted;

  /// Check if seller can quote.
  bool get canQuote => status == CustomOrderStatus.pending;

  /// Check if seller can reject.
  bool get canReject => status == CustomOrderStatus.pending;

  /// Create a copy with updated fields.
  CustomOrder copyWith({
    String? id,
    String? customerId,
    String? customerFirstName,
    String? customerLastName,
    String? sellerProfileId,
    String? sellerStoreName,
    String? title,
    String? description,
    String? location,
    String? phoneNumber,
    String? whatsappUrl,
    CustomOrderStatus? status,
    List<String>? imageUrls,
    double? quotedPrice,
    int? estimatedDays,
    String? sellerNote,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomOrder(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerFirstName: customerFirstName ?? this.customerFirstName,
      customerLastName: customerLastName ?? this.customerLastName,
      sellerProfileId: sellerProfileId ?? this.sellerProfileId,
      sellerStoreName: sellerStoreName ?? this.sellerStoreName,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      whatsappUrl: whatsappUrl ?? this.whatsappUrl,
      status: status ?? this.status,
      imageUrls: imageUrls ?? this.imageUrls,
      quotedPrice: quotedPrice ?? this.quotedPrice,
      estimatedDays: estimatedDays ?? this.estimatedDays,
      sellerNote: sellerNote ?? this.sellerNote,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Factory for creating a new order request (before submitting to API).
  factory CustomOrder.create({
    required String sellerProfileId,
    required String title,
    required String description,
    required String location,
    required String phoneNumber,
    required String whatsappUrl,
  }) {
    return CustomOrder(
      id: '',
      customerId: '',
      customerFirstName: '',
      customerLastName: '',
      sellerProfileId: sellerProfileId,
      title: title,
      description: description,
      location: location,
      phoneNumber: phoneNumber,
      whatsappUrl: whatsappUrl,
      status: CustomOrderStatus.pending,
      createdAt: DateTime.now(),
    );
  }
}
