import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/app/dependency_injection/events_dependency_injection.dart';
import 'package:flutter_application_1/features/events/domain/entities/event.dart';
import 'package:flutter_application_1/features/events/domain/entities/event_products.dart';
import 'package:flutter_application_1/features/events/domain/usecases/fetch_event_by_id_usecase.dart';
import 'package:flutter_application_1/features/events/domain/usecases/fetch_event_products_usecase.dart';
import 'package:flutter_application_1/features/events/domain/usecases/fetch_events_usecase.dart';
import 'package:flutter_application_1/features/events/domain/usecases/fetch_participating_stores_usecase.dart';
import 'package:flutter_application_1/features/markets/domain/entities/market_store.dart';

// ==================== Use Case Providers ====================

/// Provider for FetchPublicEventsUseCase.
final fetchPublicEventsUseCaseProvider = Provider<FetchPublicEventsUseCase>((
  ref,
) {
  final repo = ref.watch(eventsRepositoryProvider);
  return FetchPublicEventsUseCase(repo);
});

/// Provider for FetchUpcomingEventsUseCase.
final fetchUpcomingEventsUseCaseProvider = Provider<FetchUpcomingEventsUseCase>(
  (ref) {
    final repo = ref.watch(eventsRepositoryProvider);
    return FetchUpcomingEventsUseCase(repo);
  },
);

/// Provider for FetchEventByIdUseCase.
final fetchEventByIdUseCaseProvider = Provider<FetchEventByIdUseCase>((ref) {
  final repo = ref.watch(eventsRepositoryProvider);
  return FetchEventByIdUseCase(repo);
});

/// Provider for FetchParticipatingStoresUseCase.
final fetchParticipatingStoresUseCaseProvider =
    Provider<FetchParticipatingStoresUseCase>((ref) {
      final repo = ref.watch(eventsRepositoryProvider);
      return FetchParticipatingStoresUseCase(repo);
    });

/// Provider for FetchEventProductsUseCase.
final fetchEventProductsUseCaseProvider = Provider<FetchEventProductsUseCase>((
  ref,
) {
  final repo = ref.watch(eventsRepositoryProvider);
  return FetchEventProductsUseCase(repo);
});

// ==================== Data Providers ====================

/// Provider to fetch all public events.
final publicEventsProvider = FutureProvider<List<Event>>((ref) async {
  final usecase = ref.watch(fetchPublicEventsUseCaseProvider);
  return usecase();
});

/// Provider to fetch upcoming events.
final upcomingEventsProvider = FutureProvider<List<Event>>((ref) async {
  final usecase = ref.watch(fetchUpcomingEventsUseCaseProvider);
  return usecase();
});

/// Provider to fetch a single event by ID.
final eventByIdProvider = FutureProvider.family<Event, int>((ref, id) async {
  final usecase = ref.watch(fetchEventByIdUseCaseProvider);
  return usecase(id);
});

/// Provider to fetch participating stores for an event.
final participatingStoresProvider =
    FutureProvider.family<List<MarketStore>, int>((ref, eventId) async {
      final usecase = ref.watch(fetchParticipatingStoresUseCaseProvider);
      return usecase(eventId);
    });

/// Provider to fetch products by event tags.
final eventProductsProvider = FutureProvider.family<EventProducts, int>((
  ref,
  eventId,
) async {
  final usecase = ref.watch(fetchEventProductsUseCaseProvider);
  return usecase(eventId, limit: 20);
});
