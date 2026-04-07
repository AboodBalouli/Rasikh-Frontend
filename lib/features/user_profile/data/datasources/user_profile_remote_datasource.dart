import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/network/models/api_response.dart';
import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/features/user_profile/data/models/profile_model.dart';
import 'package:flutter_application_1/features/user_profile/data/models/store_info_model.dart';

class ProfileRemoteDatasource {
  final http.Client client;
  final TokenProvider tokenProvider;

  ProfileRemoteDatasource({required this.client, required this.tokenProvider});

  Future<Map<String, String>> _authHeaders() async {
    final String? token = await tokenProvider.getToken();
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Uri _uri(String path) => Uri.parse('${AppConfig.apiBaseUrl}$path');

  Future<ApiResponse<ProfileModel>> getMyProfile() async {
    final headers = await _authHeaders();
    final response = await client.get(_uri('/profile/me'), headers: headers);
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse.fromJson(
      decoded,
      (json) => ProfileModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<ProfileModel>> ensureMyProfile() async {
    final headers = await _authHeaders();
    final response = await client.post(
      _uri('/profile/me/ensure'),
      headers: headers,
    );
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse.fromJson(
      decoded,
      (json) => ProfileModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<ProfileModel>> updateStoreInfo(
    StoreInfoModel storeInfo,
  ) async {
    final headers = await _authHeaders();
    final body = jsonEncode(storeInfo.toUpdateJson());
    final response = await client.put(
      _uri('/profile/me/store'),
      headers: headers,
      body: body,
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse.fromJson(
      decoded,
      (json) => ProfileModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// SELLER-only: PUT `/profile/me/seller-category`
  Future<ApiResponse<ProfileModel>> updateSellerCategory({
    required int categoryId,
  }) async {
    final headers = await _authHeaders();
    final response = await client.put(
      _uri('/profile/me/seller-category'),
      headers: headers,
      body: jsonEncode({'categoryId': categoryId}),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse.fromJson(
      decoded,
      (json) => ProfileModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// upload profile picture by userId
  Future<ApiResponse<String>> uploadProfilePictureByUserId({
    required int userId,
    required String filePath,
  }) async {
    final token = await tokenProvider.getToken();
    final uri = _uri('/images/profile/user/$userId');

    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    final t = token?.trim();
    if (t != null && t.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $t';
    }

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
    return ApiResponse.fromJson(
      decoded,
      (json) => json as String, // data is "images/profile/<uuid>.<ext>"
    );
  }

  /// upload profile picture by userId (bytes variant - safe for web)
  Future<ApiResponse<String>> uploadProfilePictureByUserIdBytes({
    required int userId,
    required Uint8List bytes,
    required String filename,
  }) async {
    final token = await tokenProvider.getToken();
    final uri = _uri('/images/profile/user/$userId');

    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: filename,
        ),
      );

    final t = token?.trim();
    if (t != null && t.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $t';
    }

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
    return ApiResponse.fromJson(
      decoded,
      (json) => json as String, // data is "images/profile/<uuid>.<ext>"
    );
  }

  Future<ApiResponse<void>> deleteProfilePictureByUserId({
    required int userId,
  }) async {
    final token = await tokenProvider.getToken();

    final uri = _uri('/images/profile/user/$userId');

    final response = await client.delete(
      uri,
      headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiResponse.fromJson(decoded, (_) {});
  }
}
