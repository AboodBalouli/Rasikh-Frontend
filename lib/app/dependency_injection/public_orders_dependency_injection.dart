import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/features/public_orders/data/datasources/public_orders_remote_datasource.dart';
import 'package:flutter_application_1/features/public_orders/data/repositories/orders_repository_impl.dart';
import 'package:flutter_application_1/features/public_orders/domain/repositories/orders_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final publicOrdersHttpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final publicOrdersTokenProvider = Provider<TokenProvider>((ref) {
  final authLocal = AuthLocalDataSource();
  return _AuthLocalTokenProvider(authLocal);
});

final publicOrdersRemoteDataSourceProvider =
    Provider<PublicOrdersRemoteDatasource>((ref) {
      final client = ref.watch(publicOrdersHttpClientProvider);
      return PublicOrdersRemoteDatasource(client: client);
    });

final publicOrdersRepositoryProvider = Provider<PublicOrdersRepository>((ref) {
  final remote = ref.watch(publicOrdersRemoteDataSourceProvider);
  final tokenProvider = ref.watch(publicOrdersTokenProvider);
  return OrdersRepositoryImpl(remote: remote, tokenProvider: tokenProvider);
});

class _AuthLocalTokenProvider implements TokenProvider {
  final AuthLocalDataSource _authLocal;

  _AuthLocalTokenProvider(this._authLocal);

  @override
  Future<String?> getToken() => _authLocal.getToken();
}
