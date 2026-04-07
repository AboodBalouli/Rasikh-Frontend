import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_application_1/core/network/api_service.dart';
import 'package:flutter_application_1/core/network/api_endpoints.dart';
import 'package:flutter_application_1/core/network/models/api_response.dart';
import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/product_model.dart';
import '../models/create_product_request.dart';

/// Remote data source responsible for calling the API.
class ProductRemoteDataSource {
  final ApiService apiService;
  final TokenProvider? tokenProvider;

  ProductRemoteDataSource(this.apiService, {this.tokenProvider});

  Future<String?> _token() => tokenProvider?.getToken() ?? Future.value(null);

  Future<List<ProductModel>> fetchProducts() async {
    final raw = await apiService.get(
      ApiEndpoints.products,
      token: await _token(),
    );

    if (raw is! Map) {
      throw const FormatException('Expected JSON object response');
    }
    final api = ApiResponse<Map<String, dynamic>>.fromJson(
      Map<String, dynamic>.from(raw),
      (value) => Map<String, dynamic>.from(value as Map),
    );
    if (api.success != true || api.data == null) {
      throw Exception(api.error?.message ?? 'Failed to fetch products');
    }

    // getAll is paginated: ApiResponse.data is a page object containing `data: []`.
    final page = api.data!;
    final itemsRaw = page['data'];
    final items = itemsRaw is List ? itemsRaw : const <Object?>[];
    return items
        .whereType<Map>()
        .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<ProductModel?> fetchProductById(String id) async {
    final raw = await apiService.get(
      ApiEndpoints.productById(id),
      token: await _token(),
    );

    if (raw is! Map) {
      throw const FormatException('Expected JSON object response');
    }
    final api = ApiResponse<Map<String, dynamic>>.fromJson(
      Map<String, dynamic>.from(raw),
      (value) => Map<String, dynamic>.from(value as Map),
    );
    if (api.success != true || api.data == null) {
      throw Exception(api.error?.message ?? 'Failed to fetch product');
    }
    return ProductModel.fromJson(api.data!);
  }

  Future<List<ProductModel>> fetchProductsBySellerId(String sellerId) async {
    final raw = await apiService.get(
      ApiEndpoints.productsBySellerId(sellerId),
      token: await _token(),
    );
    if (raw is! Map) {
      throw const FormatException('Expected JSON object response');
    }

    final api = ApiResponse<Object?>.fromJson(
      Map<String, dynamic>.from(raw),
      (value) => value,
    );
    if (api.success != true) {
      throw Exception(api.error?.message ?? 'Failed to fetch seller products');
    }

    final data = api.data;
    if (data == null) return const <ProductModel>[];

    // Backend may return either a raw list, or a paginated-like object with `data: []`.
    Object? itemsRaw = data;
    if (data is Map && data['data'] is List) {
      itemsRaw = data['data'];
    }

    if (itemsRaw is! List) {
      throw const FormatException('Expected list for seller products');
    }

    final items = itemsRaw;
    return items
        .whereType<Map>()
        .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Creates a product with images using multipart form data.
  /// POST /api/product/create-with-images
  Future<ProductModel> createProductWithImages({
    required CreateProductRequest request,
    required List<Uint8List> images,
  }) async {
    final token = await _token();
    if (token == null || token.isEmpty) {
      throw Exception('Authentication required');
    }

    final uri = Uri.parse(
      '${AppConfig.apiBaseUrl}/api/product/create-with-images',
    );
    final multipartRequest = http.MultipartRequest('POST', uri);

    multipartRequest.headers['Authorization'] = 'Bearer $token';

    // Add the product JSON as a part
    multipartRequest.files.add(
      http.MultipartFile.fromString(
        'product',
        jsonEncode(request.toJson()),
        contentType: MediaType.parse('application/json'),
      ),
    );

    // Add image files
    for (int i = 0; i < images.length; i++) {
      multipartRequest.files.add(
        http.MultipartFile.fromBytes(
          'files',
          images[i],
          filename: 'image_$i.jpg',
        ),
      );
    }

    final streamedResponse = await multipartRequest.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = 'Failed to create product';
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map) {
          final error = decoded['error'];
          message =
              (error is Map ? error['message'] : null)?.toString() ??
              decoded['message']?.toString() ??
              message;
        }
      } catch (_) {}
      throw Exception(message);
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    final api = ApiResponse<Map<String, dynamic>>.fromJson(
      decoded,
      (value) => Map<String, dynamic>.from(value as Map),
    );

    if (api.success != true || api.data == null) {
      throw Exception(api.error?.message ?? 'Failed to create product');
    }

    return ProductModel.fromJson(api.data!);
  }
}
