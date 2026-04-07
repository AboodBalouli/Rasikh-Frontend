import 'package:flutter_application_1/features/events/domain/entities/event.dart';
import 'package:flutter_application_1/features/events/domain/repositories/events_repository.dart';

/// Use case to fetch public events.
class FetchPublicEventsUseCase {
  final EventsRepository _repository;

  FetchPublicEventsUseCase(this._repository);

  Future<List<Event>> call() => _repository.getPublicEvents();
}

/// Use case to fetch upcoming events.
class FetchUpcomingEventsUseCase {
  final EventsRepository _repository;

  FetchUpcomingEventsUseCase(this._repository);

  Future<List<Event>> call() => _repository.getUpcomingEvents();
}
