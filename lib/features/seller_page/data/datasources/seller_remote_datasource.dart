import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/network/models/api_response.dart';
import '../models/role_change_request_response.dart';
import '../models/profile_response.dart';
import '../models/update_store_request.dart';
import '../models/seller_product_response.dart';
import 'package:flutter_application_1/core/network/api_endpoints.dart';

class SellerRemoteDataSource {
  final http.Client client;

  SellerRemoteDataSource({required this.client});

  Uri _uri(String path) => Uri.parse('${AppConfig.apiBaseUrl}$path');

  Map<String, String> _authHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<ApiResponse<RoleChangeRequestResponse>> requestSellerRole({
    required String token,
    required int categoryId,
    required List<Uint8List> proofs, // List of 5 images
    String? note,
    Uint8List? certificate,
  }) async {
    final uri = _uri('/auth/role-change/request-seller');

    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    // request.headers['Content-Type'] = 'multipart/form-data'; // handled by MultipartRequest

    request.fields['categoryId'] = categoryId.toString();
    if (note != null) {
      request.fields['note'] = note;
    }

    // Add proofs
    for (int i = 0; i < proofs.length; i++) {
      // Filename is needed, even if just dummy
      request.files.add(
        http.MultipartFile.fromBytes(
          'proofs',
          proofs[i],
          filename: 'proof_$i.png',
          contentType: MediaType(
            'image',
            'png',
          ), // Assuming PNG/JPEG, ideally sniff type
        ),
      );
    }

    // Add certificate if present
    if (certificate != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'certificate',
          certificate,
          filename: 'certificate.png',
          contentType: MediaType('image', 'png'),
        ),
      );
    }

    final streamResponse = await client.send(request);
    final response = await http.Response.fromStream(streamResponse);

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    return ApiResponse<RoleChangeRequestResponse>.fromJson(
      json,
      (data) =>
          RoleChangeRequestResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<ProfileResponse>> getMyProfile({
    required String token,
  }) async {
    final response = await client.get(
      _uri('/profile/me'),
      headers: _authHeaders(token),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse<ProfileResponse>.fromJson(
      json,
      (data) => ProfileResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<ProfileResponse>> ensureMyProfile({
    required String token,
  }) async {
    final response = await client.post(
      _uri('/profile/me/ensure'),
      headers: _authHeaders(token),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse<ProfileResponse>.fromJson(
      json,
      (data) => ProfileResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<ProfileResponse>> updateStoreInfo({
    required UpdateStoreRequest request,
    required String token,
  }) async {
    final response = await client.put(
      _uri('/profile/me/store'),
      headers: _authHeaders(token),
      body: jsonEncode(request.toJson()),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse<ProfileResponse>.fromJson(
      json,
      (data) => ProfileResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<ProfileResponse>> updateSellerCategory({
    required int categoryId,
    required String token,
  }) async {
    final response = await client.put(
      _uri('/profile/me/seller-category'),
      headers: _authHeaders(token),
      body: jsonEncode({'categoryId': categoryId}),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse<ProfileResponse>.fromJson(
      json,
      (data) => ProfileResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<List<SellerProductResponse>>> getProductsBySellerId({
    required String sellerId,
    String? token,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await client.get(
      _uri(ApiEndpoints.productsBySellerId(sellerId)),
      headers: headers,
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse<List<SellerProductResponse>>.fromJson(json, (data) {
      final items = data is List
          ? data
          : (data is Map && data['data'] is List ? data['data'] : const []);
      final parsed = items
          .whereType<Map>()
          .map(
            (e) => SellerProductResponse.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
      return List<SellerProductResponse>.from(parsed);
    });
  }
}
