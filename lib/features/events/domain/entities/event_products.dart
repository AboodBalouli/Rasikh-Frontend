import 'event_product.dart';

/// Domain entity for products by event tags response.
class EventProducts {
  final int eventId;
  final String? eventName;
  final List<String> matchedTags;
  final List<EventProduct> products;

  const EventProducts({
    required this.eventId,
    this.eventName,
    this.matchedTags = const [],
    this.products = const [],
  });
}
