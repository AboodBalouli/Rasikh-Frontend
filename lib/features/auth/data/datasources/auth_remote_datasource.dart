/*
    This is the low-level layer → it talks to HTTP directly.

    It’s okay here to return http.Response.

    We will not use this directly in the UI.
 */

import 'package:flutter_application_1/core/network/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/auth_response.dart';

// import '../models/api_error.dart';

class AuthRemoteDataSource {
  final String baseUrl;
  final http.Client client;

  AuthRemoteDataSource({required this.baseUrl, required this.client});

  Future<ApiResponse<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    return ApiResponse<AuthResponse>.fromJson(
      decoded,
      (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<void>> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/auth/signup');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      }),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    return ApiResponse<void>.fromJson(decoded, (_) => {});
  }
}


// {
//   sucess = ture,
//   data = {

//   }

//   error = null
// }

