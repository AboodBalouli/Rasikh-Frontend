import 'dart:convert';

import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/network/models/api_response.dart';
import 'package:flutter_application_1/features/wishlists/data/models/wishlist_product_response.dart';
import 'package:http/http.dart' as http;

class WishlistRemoteDatasource {
  final http.Client client;

  WishlistRemoteDatasource({required this.client});

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

  /// GET `/api/wishlist`
  Future<ApiResponse<List<WishlistProductResponse>>> getMyWishlist({
    required String token,
  }) async {
    final url = _apiUri('/api/wishlist');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = _decodeJsonObject(response.body);
    return ApiResponse<List<WishlistProductResponse>>.fromJson(decoded, (json) {
      final list = _extractList(json)
          .map(
            (e) => WishlistProductResponse.fromJson(
              (e as Map).cast<String, dynamic>(),
            ),
          )
          .toList();
      return list;
    });
  }

  /// POST `/api/wishlist/{productId}`
  Future<ApiResponse<WishlistProductResponse>> addToWishlist({
    required String productId,
    required String token,
  }) async {
    final url = _apiUri('/api/wishlist/$productId');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = _decodeJsonObject(response.body);
    return ApiResponse<WishlistProductResponse>.fromJson(decoded, (json) {
      return WishlistProductResponse.fromJson(
        (json as Map).cast<String, dynamic>(),
      );
    });
  }

  /// DELETE `/api/wishlist/{productId}`
  Future<ApiResponse<Map<String, dynamic>>> removeFromWishlist({
    required String productId,
    required String token,
  }) async {
    final url = _apiUri('/api/wishlist/$productId');
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
}
