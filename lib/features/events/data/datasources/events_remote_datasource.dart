import 'dart:convert';

import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/network/models/api_response.dart';
import 'package:flutter_application_1/features/events/data/models/event_products_response_model.dart';
import 'package:flutter_application_1/features/events/data/models/event_response_model.dart';
import 'package:flutter_application_1/features/markets/data/models/store_response_model.dart';
import 'package:http/http.dart' as http;

/// Remote datasource for events API.
class EventsRemoteDatasource {
  final http.Client client;

  EventsRemoteDatasource({required this.client});

  static Uri _apiUri(String path) {
    return Uri.parse('${AppConfig.apiBaseUrl}$path');
  }

  /// GET `/events` - Fetch all public events.
  Future<ApiResponse<List<EventResponseModel>>> getPublicEvents() async {
    final url = _apiUri('/events');
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<List<EventResponseModel>>.fromJson(decoded, (json) {
      if (json is List) {
        return json
            .map(
              (item) =>
                  EventResponseModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }
      return [];
    });
  }

  /// GET `/events/upcoming` - Fetch upcoming public events.
  Future<ApiResponse<List<EventResponseModel>>> getUpcomingEvents() async {
    final url = _apiUri('/events/upcoming');
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<List<EventResponseModel>>.fromJson(decoded, (json) {
      if (json is List) {
        return json
            .map(
              (item) =>
                  EventResponseModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }
      return [];
    });
  }

  /// GET `/events/{id}` - Fetch single event by ID.
  Future<ApiResponse<EventResponseModel>> getEventById(int id) async {
    final url = _apiUri('/events/$id');
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<EventResponseModel>.fromJson(decoded, (json) {
      return EventResponseModel.fromJson(json as Map<String, dynamic>);
    });
  }

  /// GET `/events/{eventId}/participating-stores` - Fetch approved stores.
  Future<ApiResponse<List<StoreResponseModel>>> getParticipatingStores(
    int eventId,
  ) async {
    final url = _apiUri('/events/$eventId/participating-stores');
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<List<StoreResponseModel>>.fromJson(decoded, (json) {
      if (json is List) {
        return json
            .map(
              (item) =>
                  StoreResponseModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }
      return [];
    });
  }

  /// GET `/events/{eventId}/products?limit=20` - Fetch products by event tags.
  Future<ApiResponse<EventProductsResponseModel>> getEventProducts(
    int eventId, {
    int? limit,
  }) async {
    final base = _apiUri('/events/$eventId/products');
    final url = limit != null
        ? base.replace(queryParameters: {'limit': '$limit'})
        : base;

    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<EventProductsResponseModel>.fromJson(decoded, (json) {
      return EventProductsResponseModel.fromJson(json as Map<String, dynamic>);
    });
  }
}
