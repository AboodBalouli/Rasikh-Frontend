import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/events/data/datasources/events_remote_datasource.dart';
import 'package:flutter_application_1/features/events/data/repositories/events_repository_impl.dart';
import 'package:flutter_application_1/features/events/domain/repositories/events_repository.dart';
import 'package:http/http.dart' as http;

/// HTTP client provider for events.
final eventsHttpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

/// Remote datasource provider for events.
final eventsRemoteDatasourceProvider = Provider<EventsRemoteDatasource>((ref) {
  final client = ref.watch(eventsHttpClientProvider);
  return EventsRemoteDatasource(client: client);
});

/// Repository provider for events.
final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  final datasource = ref.watch(eventsRemoteDatasourceProvider);
  return EventsRepositoryImpl(datasource: datasource);
});
