import 'package:flutter_application_1/features/events/data/datasources/events_remote_datasource.dart';
import 'package:flutter_application_1/features/events/data/mappers/event_mapper.dart';
import 'package:flutter_application_1/features/events/domain/entities/event.dart';
import 'package:flutter_application_1/features/events/domain/entities/event_products.dart';
import 'package:flutter_application_1/features/events/domain/repositories/events_repository.dart';
import 'package:flutter_application_1/features/markets/data/mappers/market_store_mapper.dart';
import 'package:flutter_application_1/features/markets/domain/entities/market_store.dart';

/// Implementation of EventsRepository using remote datasource.
class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDatasource _datasource;
  final MarketStoreMapper _storeMapper;

  EventsRepositoryImpl({
    required EventsRemoteDatasource datasource,
    MarketStoreMapper? storeMapper,
  }) : _datasource = datasource,
       _storeMapper = storeMapper ?? const MarketStoreMapper();

  @override
  Future<List<Event>> getPublicEvents() async {
    final response = await _datasource.getPublicEvents();
    if (!response.success || response.data == null) {
      throw Exception(response.error?.message ?? 'Failed to fetch events');
    }
    return response.data!.map(mapEventResponseToEntity).toList();
  }

  @override
  Future<List<Event>> getUpcomingEvents() async {
    final response = await _datasource.getUpcomingEvents();
    if (!response.success || response.data == null) {
      throw Exception(
        response.error?.message ?? 'Failed to fetch upcoming events',
      );
    }
    return response.data!.map(mapEventResponseToEntity).toList();
  }

  @override
  Future<Event> getEventById(int id) async {
    final response = await _datasource.getEventById(id);
    if (!response.success || response.data == null) {
      throw Exception(response.error?.message ?? 'Failed to fetch event');
    }
    return mapEventResponseToEntity(response.data!);
  }

  @override
  Future<List<MarketStore>> getParticipatingStores(int eventId) async {
    final response = await _datasource.getParticipatingStores(eventId);
    if (!response.success || response.data == null) {
      throw Exception(
        response.error?.message ?? 'Failed to fetch participating stores',
      );
    }
    return response.data!.map(_storeMapper.toEntity).toList();
  }

  @override
  Future<EventProducts> getEventProducts(int eventId, {int? limit}) async {
    final response = await _datasource.getEventProducts(eventId, limit: limit);
    if (!response.success || response.data == null) {
      throw Exception(
        response.error?.message ?? 'Failed to fetch event products',
      );
    }
    return mapEventProductsResponseToEntity(response.data!);
  }
}
