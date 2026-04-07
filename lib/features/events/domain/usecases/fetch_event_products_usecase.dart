import 'package:flutter_application_1/features/events/domain/entities/event_products.dart';
import 'package:flutter_application_1/features/events/domain/repositories/events_repository.dart';

/// Use case to fetch products matching event tags.
class FetchEventProductsUseCase {
  final EventsRepository _repository;

  FetchEventProductsUseCase(this._repository);

  Future<EventProducts> call(int eventId, {int? limit}) =>
      _repository.getEventProducts(eventId, limit: limit);
}
