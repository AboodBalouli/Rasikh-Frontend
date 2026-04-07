import 'package:flutter_application_1/features/events/domain/repositories/events_repository.dart';
import 'package:flutter_application_1/features/markets/domain/entities/market_store.dart';

/// Use case to fetch participating stores for an event.
class FetchParticipatingStoresUseCase {
  final EventsRepository _repository;

  FetchParticipatingStoresUseCase(this._repository);

  Future<List<MarketStore>> call(int eventId) =>
      _repository.getParticipatingStores(eventId);
}
