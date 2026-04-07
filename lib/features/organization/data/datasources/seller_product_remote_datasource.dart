import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/network/models/api_response.dart';
import 'package:flutter_application_1/features/organization/data/models/product_rating_request.dart';
import 'package:flutter_application_1/features/organization/data/models/product_rating_response.dart';
import 'package:flutter_application_1/features/organization/data/models/seller_metrics_response.dart';
import 'package:flutter_application_1/features/organization/data/models/seller_product_request.dart';
import 'package:flutter_application_1/features/organization/data/models/seller_product_response.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/// Remote data source for seller product operations
/// Based on product.md API documentation
class SellerProductRemoteDatasource {
  final http.Client client;

  SellerProductRemoteDatasource({required this.client});

  static Uri _apiUri(String path) {
    return Uri.parse('${AppConfig.apiBaseUrl}$path');
  }

  static List<dynamic> _extractList(Object? json) {
    if (json is List<dynamic>) return json;

    if (json is Map) {
      final map = json.cast<String, dynamic>();
      // Check for common list container keys
      for (final key in const ['content', 'items', 'results', 'data']) {
        final value = map[key];
        if (value is List<dynamic>) return value;
      }
    }

    throw const FormatException(
      'Expected a List or a paginated Map containing a List',
    );
  }

  /// GET /api/product/my-products - Get current seller's products (paginated)
  Future<ApiResponse<List<SellerProductResponse>>> getMyProducts({
    required String token,
    int pageNumber = 0,
    int pageSize = 100, // Default high to get all products
    String? searchItem,
    bool sortDescending = false,
  }) async {
    final base = _apiUri('/api/product/my-products');
    final queryParams = <String, String>{
      'pageNumber': '$pageNumber',
      'pageSize': '$pageSize',
      'sortDescending': '$sortDescending',
    };
    if (searchItem != null && searchItem.isNotEmpty) {
      queryParams['searchItem'] = searchItem;
    }
    final url = base.replace(queryParameters: queryParams);

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

    return ApiResponse<List<SellerProductResponse>>.fromJson(decoded, (json) {
      final list = _extractList(json)
          .map(
            (item) =>
                SellerProductResponse.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      return list;
    });
  }

  /// GET /api/product/my/{id} - Get specific product owned by current seller
  Future<ApiResponse<SellerProductResponse>> getMyProductById({
    required int productId,
    required String token,
  }) async {
    final url = _apiUri('/api/product/my/$productId');
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

    return ApiResponse<SellerProductResponse>.fromJson(decoded, (json) {
      return SellerProductResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  /// POST /api/product/create-with-images - Create product with images
  Future<ApiResponse<SellerProductResponse>> createProductWithImages({
    required SellerProductRequest productData,
    required List<Uint8List> imageBytes,
    required String token,
  }) async {
    final url = _apiUri('/api/product/create-with-images');
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    // Add product data as JSON part
    request.files.add(
      http.MultipartFile.fromString(
        'product',
        jsonEncode(productData.toJson()),
        contentType: MediaType('application', 'json'),
      ),
    );

    // Add images
    for (var i = 0; i < imageBytes.length; i++) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'files',
          imageBytes[i],
          filename: 'product_image_${i + 1}.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<SellerProductResponse>.fromJson(decoded, (json) {
      return SellerProductResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  /// POST /api/product/create - Create product without images
  Future<ApiResponse<SellerProductResponse>> createProduct({
    required SellerProductRequest productData,
    required String token,
  }) async {
    final url = _apiUri('/api/product/create');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(productData.toJson()),
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<SellerProductResponse>.fromJson(decoded, (json) {
      return SellerProductResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  /// PUT /api/product/my/{id}/update - Update seller's own product
  Future<ApiResponse<SellerProductResponse>> updateMyProduct({
    required int productId,
    required SellerProductRequest productData,
    required String token,
  }) async {
    final url = _apiUri('/api/product/my/$productId/update');
    final response = await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(productData.toJson()),
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<SellerProductResponse>.fromJson(decoded, (json) {
      return SellerProductResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  /// PUT /api/product/user/soft-deleteOrRestoreById/{id} - Toggle product visibility
  Future<ApiResponse<String>> softDeleteProduct({
    required int productId,
    required String token,
  }) async {
    final url = _apiUri(
      '/api/product/user/soft-deleteOrRestoreById/$productId',
    );
    final response = await client.put(
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

    return ApiResponse<String>.fromJson(decoded, (json) {
      return (json ?? '').toString();
    });
  }

  /// POST /api/product/restoreById/{id} - Restore a soft-deleted product
  Future<ApiResponse<SellerProductResponse>> restoreProduct({
    required int productId,
    required String token,
  }) async {
    final url = _apiUri('/api/product/restoreById/$productId');
    final response = await client.post(
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

    return ApiResponse<SellerProductResponse>.fromJson(decoded, (json) {
      return SellerProductResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  /// POST /images/product/{productId} - Upload images for existing product
  Future<ApiResponse<String>> uploadProductImages({
    required int productId,
    required List<Uint8List> imageBytes,
    required String token,
  }) async {
    final url = _apiUri('/images/product/$productId');
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    for (var i = 0; i < imageBytes.length; i++) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'files',
          imageBytes[i],
          filename: 'product_image_${i + 1}.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<String>.fromJson(decoded, (json) {
      return (json ?? '').toString();
    });
  }

  /// GET /api/product/my/metrics - Get seller metrics
  Future<ApiResponse<SellerMetricsResponse>> getMyMetrics({
    required String token,
  }) async {
    final url = _apiUri('/api/product/my/metrics');
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

    return ApiResponse<SellerMetricsResponse>.fromJson(decoded, (json) {
      return SellerMetricsResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  /// POST /api/product/rate - Rate a product
  Future<ApiResponse<ProductRatingResponse>> rateProduct({
    required ProductRatingRequest request,
    required String token,
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

    return ApiResponse<ProductRatingResponse>.fromJson(decoded, (json) {
      return ProductRatingResponse.fromJson(json as Map<String, dynamic>);
    });
  }

  /// DELETE /api/product/{productId}/rate - Delete product rating
  Future<ApiResponse<Map<String, dynamic>>> deleteProductRating({
    required int productId,
    required String token,
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

  /// GET /api/product/{productId}/ratings - Get all ratings for a product
  Future<ApiResponse<List<ProductRatingResponse>>> getProductRatings(
    int productId,
  ) async {
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

  /// GET /api/product/sellers-products/{sellerId} - Get products by seller ID (public)
  Future<ApiResponse<List<SellerProductResponse>>> getProductsBySellerId({
    required String sellerId,
    int pageNumber = 0,
    int pageSize = 10,
    String? searchItem,
    bool sortDescending = false,
  }) async {
    final base = _apiUri('/api/product/sellers-products/$sellerId');
    final queryParams = <String, String>{
      'pageNumber': '$pageNumber',
      'pageSize': '$pageSize',
      'sortDescending': '$sortDescending',
    };
    if (searchItem != null && searchItem.isNotEmpty) {
      queryParams['searchItem'] = searchItem;
    }
    final url = base.replace(queryParameters: queryParams);

    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<List<SellerProductResponse>>.fromJson(decoded, (json) {
      final list = _extractList(json)
          .map(
            (item) =>
                SellerProductResponse.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      return list;
    });
  }
}
