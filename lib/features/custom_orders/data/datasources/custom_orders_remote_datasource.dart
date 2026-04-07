import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/network/models/api_response.dart';
import 'package:flutter_application_1/core/network/token_provider.dart';
import '../models/custom_order_request.dart';
import '../models/custom_order_response.dart';

/// Remote datasource for custom order API calls.
class CustomOrdersRemoteDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  CustomOrdersRemoteDatasource({
    required this.client,
    required this.tokenProvider,
  });

  Uri _uri(String path) => Uri.parse('${AppConfig.apiBaseUrl}$path');

  Future<Map<String, String>> _authHeaders() async {
    final token = await tokenProvider.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
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
    return [];
  }

  /// POST /api/custom-order-requests
  Future<ApiResponse<CustomOrderResponse>> createCustomOrder(
    CustomOrderRequest request,
  ) async {
    final response = await client.post(
      _uri('/api/custom-order-requests'),
      headers: await _authHeaders(),
      body: jsonEncode(request.toJson()),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse<CustomOrderResponse>.fromJson(
      decoded,
      (json) => CustomOrderResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /api/custom-order-requests/create-with-images (multipart)
  Future<ApiResponse<CustomOrderResponse>> createCustomOrderWithImages({
    required CustomOrderRequest request,
    required List<File> files,
  }) async {
    final token = await tokenProvider.getToken();
    final uri = _uri('/api/custom-order-requests/create-with-images');
    final multipart = http.MultipartRequest('POST', uri);

    if (token != null) {
      multipart.headers['Authorization'] = 'Bearer $token';
    }

    // Add JSON part
    multipart.fields['request'] = jsonEncode(request.toJson());

    // Add files
    for (final file in files) {
      final multipartFile = await http.MultipartFile.fromPath(
        'files',
        file.path,
      );
      multipart.files.add(multipartFile);
    }

    final streamed = await client.send(multipart);
    final response = await http.Response.fromStream(streamed);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse<CustomOrderResponse>.fromJson(
      decoded,
      (json) => CustomOrderResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// GET /api/custom-order-requests/my
  Future<ApiResponse<List<CustomOrderResponse>>> getMyCustomOrders() async {
    final response = await client.get(
      _uri('/api/custom-order-requests/my'),
      headers: await _authHeaders(),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse<List<CustomOrderResponse>>.fromJson(decoded, (json) {
      final list = _extractList(json);
      return list
          .map((e) => CustomOrderResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  /// GET /api/custom-order-requests/{id}
  Future<ApiResponse<CustomOrderResponse>> getCustomOrderById(String id) async {
    final response = await client.get(
      _uri('/api/custom-order-requests/$id'),
      headers: await _authHeaders(),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse<CustomOrderResponse>.fromJson(
      decoded,
      (json) => CustomOrderResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// PUT /api/custom-order-requests/{id}
  Future<ApiResponse<CustomOrderResponse>> updateCustomOrder({
    required String id,
    required CustomOrderUpdateRequest request,
  }) async {
    final response = await client.put(
      _uri('/api/custom-order-requests/$id'),
      headers: await _authHeaders(),
      body: jsonEncode(request.toJson()),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse<CustomOrderResponse>.fromJson(
      decoded,
      (json) => CustomOrderResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /api/custom-order-requests/{id}/cancel
  Future<ApiResponse<CustomOrderResponse>> cancelCustomOrder(String id) async {
    final response = await client.post(
      _uri('/api/custom-order-requests/$id/cancel'),
      headers: await _authHeaders(),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse<CustomOrderResponse>.fromJson(
      decoded,
      (json) => CustomOrderResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// PUT /api/custom-order-requests/{id}/accept
  Future<ApiResponse<CustomOrderResponse>> acceptQuote(String id) async {
    final response = await client.put(
      _uri('/api/custom-order-requests/$id/accept'),
      headers: await _authHeaders(),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse<CustomOrderResponse>.fromJson(
      decoded,
      (json) => CustomOrderResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// GET /api/custom-order-requests/inbox (SELLER)
  Future<ApiResponse<List<CustomOrderResponse>>> getSellerInbox() async {
    final response = await client.get(
      _uri('/api/custom-order-requests/inbox'),
      headers: await _authHeaders(),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse<List<CustomOrderResponse>>.fromJson(decoded, (json) {
      final list = _extractList(json);
      return list
          .map((e) => CustomOrderResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  /// PUT /api/custom-order-requests/{id}/quote (SELLER)
  Future<ApiResponse<CustomOrderResponse>> quoteCustomOrder({
    required String id,
    required CustomOrderQuoteRequest request,
  }) async {
    final response = await client.put(
      _uri('/api/custom-order-requests/$id/quote'),
      headers: await _authHeaders(),
      body: jsonEncode(request.toJson()),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse<CustomOrderResponse>.fromJson(
      decoded,
      (json) => CustomOrderResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /api/custom-order-requests/{id}/reject (SELLER)
  Future<ApiResponse<CustomOrderResponse>> rejectCustomOrder(String id) async {
    final response = await client.post(
      _uri('/api/custom-order-requests/$id/reject'),
      headers: await _authHeaders(),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse<CustomOrderResponse>.fromJson(
      decoded,
      (json) => CustomOrderResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
