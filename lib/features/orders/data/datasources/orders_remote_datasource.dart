import 'dart:convert';

import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/network/models/api_response.dart';
import 'package:flutter_application_1/features/orders/data/models/create_order_request_model.dart';
import 'package:flutter_application_1/features/orders/data/models/order_response_model.dart';
import 'package:flutter_application_1/features/orders/data/models/update_order_status_request_model.dart';
import 'package:http/http.dart' as http;

class OrdersRemoteDatasource {
  final http.Client client;

  OrdersRemoteDatasource({required this.client});

  static Uri _apiUri(String path) {
    return Uri.parse('${AppConfig.apiBaseUrl}$path');
  }

  static Map<String, dynamic> _decodeJsonObject(String body) {
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }
    return decoded;
  }

  static List<dynamic> _extractList(Object? json) {
    if (json is List<dynamic>) return json;

    if (json is Map) {
      final map = json.cast<String, dynamic>();
      for (final key in const ['content', 'items', 'results', 'data']) {
        final value = map[key];
        if (value is List<dynamic>) return value;
      }
    }

    throw const FormatException(
      'Expected a List or a Map containing a List under content/items/results/data',
    );
  }

  /// POST `/api/orders`
  Future<ApiResponse<OrderResponseModel>> createOrder({
    required CreateOrderRequestModel request,
    required String token,
  }) async {
    final url = _apiUri('/api/orders');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    final decoded = _decodeJsonObject(response.body);
    return ApiResponse<OrderResponseModel>.fromJson(decoded, (json) {
      return OrderResponseModel.fromJson((json as Map).cast<String, dynamic>());
    });
  }

  /// GET `/api/orders`
  Future<ApiResponse<List<OrderResponseModel>>> getMyOrders({
    required String token,
  }) async {
    final url = _apiUri('/api/orders');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = _decodeJsonObject(response.body);
    return ApiResponse<List<OrderResponseModel>>.fromJson(decoded, (json) {
      final list = _extractList(json)
          .map(
            (e) =>
                OrderResponseModel.fromJson((e as Map).cast<String, dynamic>()),
          )
          .toList();
      return list;
    });
  }

  /// GET `/api/orders/status/{status}`
  Future<ApiResponse<List<OrderResponseModel>>> getMyOrdersByStatus({
    required String status,
    required String token,
  }) async {
    final url = _apiUri('/api/orders/status/$status');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = _decodeJsonObject(response.body);
    return ApiResponse<List<OrderResponseModel>>.fromJson(decoded, (json) {
      final list = _extractList(json)
          .map(
            (e) =>
                OrderResponseModel.fromJson((e as Map).cast<String, dynamic>()),
          )
          .toList();
      return list;
    });
  }

  /// GET `/api/orders/{orderId}`
  Future<ApiResponse<OrderResponseModel>> getOrderById({
    required int orderId,
    required String token,
  }) async {
    final url = _apiUri('/api/orders/$orderId');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = _decodeJsonObject(response.body);
    return ApiResponse<OrderResponseModel>.fromJson(decoded, (json) {
      return OrderResponseModel.fromJson((json as Map).cast<String, dynamic>());
    });
  }

  /// PUT `/api/orders/{orderId}/status`
  Future<ApiResponse<OrderResponseModel>> updateOrderStatus({
    required int orderId,
    required UpdateOrderStatusRequestModel request,
    required String token,
  }) async {
    final url = _apiUri('/api/orders/$orderId/status');
    final response = await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    final decoded = _decodeJsonObject(response.body);
    return ApiResponse<OrderResponseModel>.fromJson(decoded, (json) {
      return OrderResponseModel.fromJson((json as Map).cast<String, dynamic>());
    });
  }

  /// POST `/api/orders/{orderId}/cancel`
  Future<ApiResponse<OrderResponseModel>> cancelOrder({
    required int orderId,
    required String token,
  }) async {
    final url = _apiUri('/api/orders/$orderId/cancel');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = _decodeJsonObject(response.body);
    return ApiResponse<OrderResponseModel>.fromJson(decoded, (json) {
      return OrderResponseModel.fromJson((json as Map).cast<String, dynamic>());
    });
  }

  /// DELETE `/api/orders/{orderId}`
  Future<ApiResponse<Map<String, dynamic>>> deleteOrder({
    required int orderId,
    required String token,
  }) async {
    final url = _apiUri('/api/orders/$orderId');
    final response = await client.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = _decodeJsonObject(response.body);
    return ApiResponse<Map<String, dynamic>>.fromJson(decoded, (json) {
      return (json as Map).cast<String, dynamic>();
    });
  }

  /// GET `/api/orders/count`
  Future<ApiResponse<int>> getMyOrdersCount({required String token}) async {
    final url = _apiUri('/api/orders/count');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = _decodeJsonObject(response.body);
    return ApiResponse<int>.fromJson(decoded, (json) {
      if (json is num) return json.toInt();
      if (json is String) return int.tryParse(json) ?? 0;
      return 0;
    });
  }
}
