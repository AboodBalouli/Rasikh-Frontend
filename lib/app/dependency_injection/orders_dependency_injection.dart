import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:flutter_application_1/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:flutter_application_1/features/orders/domain/repositories/orders_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final ordersHttpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final ordersTokenProvider = Provider<TokenProvider>((ref) {
  final authLocal = AuthLocalDataSource();
  return _AuthLocalTokenProvider(authLocal);
});

final ordersRemoteDataSourceProvider = Provider<OrdersRemoteDatasource>((ref) {
  final client = ref.watch(ordersHttpClientProvider);
  return OrdersRemoteDatasource(client: client);
});

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  final remote = ref.watch(ordersRemoteDataSourceProvider);
  final tokenProvider = ref.watch(ordersTokenProvider);
  return OrdersRepositoryImpl(remote: remote, tokenProvider: tokenProvider);
});

class _AuthLocalTokenProvider implements TokenProvider {
  final AuthLocalDataSource _authLocal;

  _AuthLocalTokenProvider(this._authLocal);

  @override
  Future<String?> getToken() => _authLocal.getToken();
}
