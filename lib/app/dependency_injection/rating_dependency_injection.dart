import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/features/rating/data/datasources/rating_remote_datasource.dart';
import 'package:flutter_application_1/features/rating/data/repositories/rating_repository_impl.dart';
import 'package:flutter_application_1/features/rating/domain/repositories/rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// HTTP client for rating API calls.
final ratingHttpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

/// Token provider for authenticated rating operations.
final ratingTokenProvider = Provider<TokenProvider>((ref) {
  final authLocal = AuthLocalDataSource();
  return _AuthLocalTokenProvider(authLocal);
});

/// Remote datasource for rating API.
final ratingRemoteDataSourceProvider = Provider<RatingRemoteDatasource>((ref) {
  final client = ref.watch(ratingHttpClientProvider);
  return RatingRemoteDatasource(client: client);
});

/// Rating repository provider.
final ratingRepositoryProvider = Provider<RatingRepository>((ref) {
  final remote = ref.watch(ratingRemoteDataSourceProvider);
  final tokenProvider = ref.watch(ratingTokenProvider);
  return RatingRepositoryImpl(remote: remote, tokenProvider: tokenProvider);
});

class _AuthLocalTokenProvider implements TokenProvider {
  final AuthLocalDataSource _authLocal;

  _AuthLocalTokenProvider(this._authLocal);

  @override
  Future<String?> getToken() => _authLocal.getToken();
}
