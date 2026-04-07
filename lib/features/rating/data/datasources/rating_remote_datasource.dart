import 'package:flutter_application_1/core/network/models/api_response.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product_rating_response.dart';
import '../models/store_rating_response.dart';
import '../models/rate_product_request.dart';
import '../models/rate_store_request.dart';

/// Remote datasource for rating-related API calls.
class RatingRemoteDatasource {
  final http.Client client;

  RatingRemoteDatasource({required this.client});

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
      'Expected a List or a paginated Map containing a List',
    );
  }

  /// POST /api/product/rate
  Future<ApiResponse<Map<String, dynamic>>> rateProduct({
    required String token,
    required RateProductRequest request,
  }) async {
    final url = _apiUri('/api/product/rate');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<Map<String, dynamic>>.fromJson(decoded, (json) {
      return (json as Map).cast<String, dynamic>();
    });
  }

  /// DELETE /api/product/{productId}/rate
  Future<ApiResponse<Map<String, dynamic>>> deleteProductRating({
    required String token,
    required int productId,
  }) async {
    final url = _apiUri('/api/product/$productId/rate');
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

  /// GET /api/product/{productId}/ratings
  Future<ApiResponse<List<ProductRatingResponse>>> getProductRatings({
    required int productId,
  }) async {
    final url = _apiUri('/api/product/$productId/ratings');
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<List<ProductRatingResponse>>.fromJson(decoded, (json) {
      final list = _extractList(json)
          .map(
            (item) =>
                ProductRatingResponse.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      return list;
    });
  }

  /// POST /profile/stores/{sellerProfileId}/rate
  Future<ApiResponse<Map<String, dynamic>>> rateStore({
    required String token,
    required int sellerProfileId,
    required RateStoreRequest request,
  }) async {
    final url = _apiUri('/profile/stores/$sellerProfileId/rate');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<Map<String, dynamic>>.fromJson(decoded, (json) {
      return (json as Map).cast<String, dynamic>();
    });
  }

  /// GET /profile/stores/{sellerProfileId}/ratings
  Future<ApiResponse<List<StoreRatingResponse>>> getStoreRatings({
    required int sellerProfileId,
  }) async {
    final url = _apiUri('/profile/stores/$sellerProfileId/ratings');
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<List<StoreRatingResponse>>.fromJson(decoded, (json) {
      final list = _extractList(json)
          .map(
            (item) =>
                StoreRatingResponse.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      return list;
    });
  }
}
