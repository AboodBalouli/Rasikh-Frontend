import 'event_product_model.dart';

/// DTO for the event products by tag response from the backend.
/// Matches backend EventProductsByTagResponse.
class EventProductsResponseModel {
  final int eventId;
  final String? eventName;
  final List<String> matchedTags;
  final List<EventProductModel> products;

  const EventProductsResponseModel({
    required this.eventId,
    this.eventName,
    this.matchedTags = const [],
    this.products = const [],
  });

  factory EventProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return EventProductsResponseModel(
      eventId: (json['eventId'] as num?)?.toInt() ?? 0,
      eventName: json['eventName'] as String?,
      matchedTags:
          (json['matchedTags'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      products:
          (json['products'] as List?)
              ?.map(
                (item) =>
                    EventProductModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}
