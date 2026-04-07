import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/network/api_service.dart';
import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/core/storage/secure_storage_token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// Shared Riverpod providers used by the migrated coworker features.

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final tokenProvider = Provider<TokenProvider>((ref) {
  return const SecureStorageTokenProvider();
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final client = ref.watch(httpClientProvider);
  return ApiService(client: client, baseUrl: AppConfig.apiBaseUrl);
});

/// Convenience provider for an auth token stored in secure storage.
final authTokenProvider = FutureProvider<String?>((ref) async {
  final provider = ref.watch(tokenProvider);
  return provider.getToken();
});
