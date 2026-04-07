import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/core/network/models/api_response.dart';

class ProductRemoteDatasource {
  final http.Client _client;
  final String baseUrl;

  ProductRemoteDatasource(this.baseUrl, {http.Client? client})
    : _client = client ?? http.Client();

  Future<Map<String, dynamic>> getAllProducts({
    required int pageNumber,
    required int pageSize,
    String? searchItem,
    bool sortDescending = false,
  }) async {
    final query = <String, String>{
      'pageNumber': '$pageNumber',
      'pageSize': '$pageSize',
      'sortDescending': '$sortDescending',
    };
    final trimmedSearch = searchItem?.trim();
    if (trimmedSearch != null && trimmedSearch.isNotEmpty) {
      query['searchItem'] = trimmedSearch;
    }

    final uri = Uri.parse(
      '$baseUrl/api/product/getAll',
    ).replace(queryParameters: query);

    final response = await _client.get(
      uri,
      headers: const {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    // Surface backend error message when possible.
    final api = ApiResponse<Object?>.fromJson(decoded, (json) => json);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(api.error?.message ?? 'Server error');
    }
    if (api.success != true) {
      throw Exception(api.error?.message ?? 'Request failed');
    }

    return decoded;
  }
}
