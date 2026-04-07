import 'dart:convert';

import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/network/models/api_response.dart';
import 'package:flutter_application_1/features/cart/data/models/add_cart_item_request.dart';
import 'package:flutter_application_1/features/cart/data/models/cart_item_response.dart';
import 'package:flutter_application_1/features/cart/data/models/cart_response.dart';
import 'package:flutter_application_1/features/cart/data/models/update_cart_item_quantity_request.dart';
import 'package:http/http.dart' as http;

class CartRemoteDatasource {
  final http.Client client;

  CartRemoteDatasource({required this.client});

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

  /// GET `/api/cart`
  Future<ApiResponse<CartResponse>> getMyCart({required String token}) async {
    final url = _apiUri('/api/cart');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = _decodeJsonObject(response.body);
    return ApiResponse<CartResponse>.fromJson(decoded, (json) {
      return CartResponse.fromJson((json as Map).cast<String, dynamic>());
    });
  }

  /// POST `/api/cart`
  Future<ApiResponse<CartItemResponse>> addItemToCart({
    required AddCartItemRequest request,
    required String token,
  }) async {
    final url = _apiUri('/api/cart');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    final decoded = _decodeJsonObject(response.body);
    return ApiResponse<CartItemResponse>.fromJson(decoded, (json) {
      return CartItemResponse.fromJson((json as Map).cast<String, dynamic>());
    });
  }

  /// PUT `/api/cart/{cartItemId}`
  Future<ApiResponse<CartItemResponse>> updateCartItemQuantity({
    required int cartItemId,
    required UpdateCartItemQuantityRequest update,
    required String token,
  }) async {
    final url = _apiUri('/api/cart/$cartItemId');
    final response = await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(update.toJson()),
    );

    final decoded = _decodeJsonObject(response.body);
    return ApiResponse<CartItemResponse>.fromJson(decoded, (json) {
      return CartItemResponse.fromJson((json as Map).cast<String, dynamic>());
    });
  }

  /// DELETE `/api/cart/{cartItemId}`
  Future<ApiResponse<Map<String, dynamic>>> removeItemFromCart({
    required int cartItemId,
    required String token,
  }) async {
    final url = _apiUri('/api/cart/$cartItemId');
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

  /// DELETE `/api/cart`
  Future<ApiResponse<Map<String, dynamic>>> clearCart({
    required String token,
  }) async {
    final url = _apiUri('/api/cart');
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

  /// GET `/api/cart/count`
  Future<ApiResponse<int>> getCartItemsCount({required String token}) async {
    final url = _apiUri('/api/cart/count');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = _decodeJsonObject(response.body);
    return ApiResponse<int>.fromJson(decoded, (json) {
      if (json is int) return json;
      if (json is num) return json.toInt();
      return int.parse(json.toString());
    });
  }
}
