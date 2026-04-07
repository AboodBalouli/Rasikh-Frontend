import 'package:flutter_application_1/features/events/domain/entities/event.dart';
import 'package:flutter_application_1/features/events/domain/repositories/events_repository.dart';

/// Use case to fetch a single event by ID.
class FetchEventByIdUseCase {
  final EventsRepository _repository;

  FetchEventByIdUseCase(this._repository);

  Future<Event> call(int id) => _repository.getEventById(id);
}
