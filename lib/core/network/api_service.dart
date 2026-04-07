import 'dart:convert';

import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:http/http.dart' as http;

/// Lightweight JSON HTTP client used by the migrated features.
///
/// This intentionally returns `dynamic` (decoded JSON) because some features
/// expect raw Map/List payloads rather than a typed ApiResponse.
class ApiService {
  final http.Client _client;
  final String _baseUrl;

  ApiService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = (baseUrl ?? AppConfig.apiBaseUrl).trim();

  Uri _uri(String pathOrUrl, [Map<String, String>? queryParameters]) {
    final trimmed = pathOrUrl.trim();
    final isAbsolute =
        trimmed.startsWith('http://') || trimmed.startsWith('https://');
    final url = isAbsolute
        ? trimmed
        : trimmed.startsWith('/')
        ? '$_baseUrl$trimmed'
        : '$_baseUrl/$trimmed';

    final uri = Uri.parse(url);
    if (queryParameters == null || queryParameters.isEmpty) return uri;
    return uri.replace(
      queryParameters: {...uri.queryParameters, ...queryParameters},
    );
  }

  Map<String, String> _headers({String? token, Map<String, String>? extra}) {
    final headers = <String, String>{'Content-Type': 'application/json'};
    final t = token?.trim();
    if (t != null && t.isNotEmpty) {
      headers['Authorization'] = 'Bearer $t';
    }
    if (extra != null && extra.isNotEmpty) headers.addAll(extra);
    return headers;
  }

  dynamic _decode(http.Response response) {
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }

  void _ensureSuccess(http.Response response, {required String method}) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    dynamic decoded;
    try {
      decoded = _decode(response);
    } catch (_) {
      decoded = null;
    }

    String message;
    if (decoded is Map) {
      final error = decoded['error'];
      message =
          (error is Map ? error['message'] : null)?.toString() ??
          decoded.toString();
    } else {
      final body = response.body.trim();
      message = body.isEmpty ? 'HTTP ${response.statusCode}' : body;
    }

    if (message.length > 300) message = message.substring(0, 300);
    throw Exception('$method failed (${response.statusCode}): $message');
  }

  Future<dynamic> get(
    String pathOrUrl, {
    Map<String, String>? queryParameters,
    String? token,
    Map<String, String>? headers,
  }) async {
    final response = await _client.get(
      _uri(pathOrUrl, queryParameters),
      headers: _headers(token: token, extra: headers),
    );
    _ensureSuccess(response, method: 'GET');
    return _decode(response);
  }

  Future<dynamic> post(
    String pathOrUrl,
    Object? body, {
    Map<String, String>? queryParameters,
    String? token,
    Map<String, String>? headers,
  }) async {
    final response = await _client.post(
      _uri(pathOrUrl, queryParameters),
      headers: _headers(token: token, extra: headers),
      body: jsonEncode(body),
    );
    _ensureSuccess(response, method: 'POST');
    return _decode(response);
  }

  Future<dynamic> put(
    String pathOrUrl,
    Object? body, {
    Map<String, String>? queryParameters,
    String? token,
    Map<String, String>? headers,
  }) async {
    final response = await _client.put(
      _uri(pathOrUrl, queryParameters),
      headers: _headers(token: token, extra: headers),
      body: jsonEncode(body),
    );
    _ensureSuccess(response, method: 'PUT');
    return _decode(response);
  }

  Future<dynamic> delete(
    String pathOrUrl, {
    Map<String, String>? queryParameters,
    String? token,
    Map<String, String>? headers,
  }) async {
    final response = await _client.delete(
      _uri(pathOrUrl, queryParameters),
      headers: _headers(token: token, extra: headers),
    );
    _ensureSuccess(response, method: 'DELETE');
    return _decode(response);
  }
}
