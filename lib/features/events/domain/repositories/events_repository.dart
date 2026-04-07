import 'package:flutter_application_1/features/events/domain/entities/event.dart';
import 'package:flutter_application_1/features/events/domain/entities/event_products.dart';
import 'package:flutter_application_1/features/markets/domain/entities/market_store.dart';

/// Abstract repository contract for events feature.
abstract class EventsRepository {
  /// Fetch all public events.
  Future<List<Event>> getPublicEvents();

  /// Fetch upcoming public events (endDate > now).
  Future<List<Event>> getUpcomingEvents();

  /// Fetch a single event by ID.
  Future<Event> getEventById(int id);

  /// Fetch approved participating stores for an event.
  Future<List<MarketStore>> getParticipatingStores(int eventId);

  /// Fetch products matching event tags.
  Future<EventProducts> getEventProducts(int eventId, {int? limit});
}
