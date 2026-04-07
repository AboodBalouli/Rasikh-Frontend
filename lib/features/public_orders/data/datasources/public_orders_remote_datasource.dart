import 'package:flutter_application_1/core/network/models/api_response.dart';
import 'package:flutter_application_1/features/public_orders/data/models/public_order_request.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/public_order_response.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'dart:io';

import '../models/public_order_image_response.dart';
import '../models/public_order_status_update_request.dart';
import '../models/public_order_update_request.dart';

class PublicOrdersRemoteDatasource {
  final http.Client client;

  PublicOrdersRemoteDatasource({required this.client});

  static Uri _apiUri(String path) {
    return Uri.parse('${AppConfig.apiBaseUrl}$path');
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
      'Expected a List or a paginated Map containing a List under content/items/results/data',
    );
  }

  /// GET `/api/public-orders?pageNumber=0&pageSize=10`
  Future<ApiResponse<List<PublicOrderResponse>>> getPublicOrders({
    required int pageNumber,
    int pageSize = 10,
  }) async {
    final base = _apiUri('/api/public-orders');
    final url = base.replace(
      queryParameters: {'pageNumber': '$pageNumber', 'pageSize': '$pageSize'},
    );

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<List<PublicOrderResponse>>.fromJson(decoded, (json) {
      final list = _extractList(json)
          .map(
            (item) =>
                PublicOrderResponse.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      return list;
    });
  }

  /// GET `/api/public-orders/{id}`
  Future<ApiResponse<PublicOrderResponse>> getPublicOrderById(
    String id,
  ) async {
    final url = _apiUri('/api/public-orders/$id');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<PublicOrderResponse>.fromJson(decoded, (json) {
      return PublicOrderResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  /// GET `/api/public-orders/my`
  Future<ApiResponse<List<PublicOrderResponse>>> getMyPublicOrders(
    String token,
  ) async {
    final url = _apiUri('/api/public-orders/my');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<List<PublicOrderResponse>>.fromJson(decoded, (json) {
      final list = _extractList(json)
          .map(
            (item) =>
                PublicOrderResponse.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      return list;
    });
  }

  /// GET `/api/public-orders/status/{status}?pageNumber=0&pageSize=10`
  Future<ApiResponse<List<PublicOrderResponse>>> getPublicOrdersByStatus({
    required String status,
    required int pageNumber,
    int pageSize = 10,
  }) async {
    final base = _apiUri('/api/public-orders/status/$status');
    final url = base.replace(
      queryParameters: {'pageNumber': '$pageNumber', 'pageSize': '$pageSize'},
    );

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<List<PublicOrderResponse>>.fromJson(decoded, (json) {
      final list = _extractList(json)
          .map(
            (item) =>
                PublicOrderResponse.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      return list;
    });
  }

  /// POST `/api/public-orders`
  Future<ApiResponse<PublicOrderResponse>> createPublicOrder(
    PublicOrderRequest order,
    String token,
  ) async {
    final url = _apiUri('/api/public-orders');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(order.toJson()),
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<PublicOrderResponse>.fromJson(decoded, (json) {
      return PublicOrderResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  /// PUT `/api/public-orders/{id}`
  Future<ApiResponse<PublicOrderResponse>> updatePublicOrder({
    required String id,
    required PublicOrderUpdateRequest update,
    required String token,
  }) async {
    final url = _apiUri('/api/public-orders/$id');
    final response = await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(update.toJson()),
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<PublicOrderResponse>.fromJson(decoded, (json) {
      return PublicOrderResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  /// PUT `/api/public-orders/{id}/status`
  Future<ApiResponse<PublicOrderResponse>> updatePublicOrderStatus({
    required String id,
    required PublicOrderStatusUpdateRequest update,
    required String token,
  }) async {
    final url = _apiUri('/api/public-orders/$id/status');
    final response = await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(update.toJson()),
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<PublicOrderResponse>.fromJson(decoded, (json) {
      return PublicOrderResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  /// DELETE `/api/public-orders/{id}`
  Future<ApiResponse<Map<String, dynamic>>> deletePublicOrder({
    required String id,
    required String token,
  }) async {
    final url = _apiUri('/api/public-orders/$id');
    final response = await client.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<Map<String, dynamic>>.fromJson(decoded, (json) {
      return (json as Map).cast<String, dynamic>();
    });
  }

  /// GET `/api/public-orders/my/count`
  Future<ApiResponse<int>> getMyOrdersCount(String token) async {
    final url = _apiUri('/api/public-orders/my/count');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<int>.fromJson(decoded, (json) {
      if (json is int) return json;
      if (json is num) return json.toInt();
      return int.parse(json.toString());
    });
  }

  /// POST `/images/public-order/{publicOrderId}` (multipart)
  Future<ApiResponse<String>> uploadPublicOrderImages({
    required String publicOrderId,
    required List<File> files,
    required String token,
  }) async {
    final url = _apiUri('/images/public-order/$publicOrderId');
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    for (final file in files) {
      final multipart = await http.MultipartFile.fromPath('files', file.path);
      request.files.add(multipart);
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<String>.fromJson(decoded, (json) {
      return json?.toString() ?? '';
    });
  }

  /// GET `/images/public-order/{publicOrderId}`
  Future<ApiResponse<List<PublicOrderImageResponse>>> getPublicOrderImages(
    String publicOrderId,
  ) async {
    final url = _apiUri('/images/public-order/$publicOrderId');
    final response = await client.get(
      url,
      headers: const {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<List<PublicOrderImageResponse>>.fromJson(decoded, (
      json,
    ) {
      final list = _extractList(json)
          .map(
            (item) =>
                PublicOrderImageResponse.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      return list;
    });
  }

  /// DELETE `/images/public-order/image/{imageId}`
  Future<ApiResponse<Map<String, dynamic>>> deletePublicOrderImage({
    required int imageId,
    required String token,
  }) async {
    final url = _apiUri('/images/public-order/image/$imageId');
    final response = await client.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<Map<String, dynamic>>.fromJson(decoded, (json) {
      return (json as Map).cast<String, dynamic>();
    });
  }
}
