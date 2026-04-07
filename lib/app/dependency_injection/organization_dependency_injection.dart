import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/features/organization/data/datasources/organization_remote_datasource.dart';
import 'package:flutter_application_1/features/organization/data/repositories/organization_repository_impl.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/organization_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final organizationHttpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final organizationTokenProvider = Provider<TokenProvider>((ref) {
  final authLocal = AuthLocalDataSource();
  return _AuthLocalTokenProvider(authLocal);
});

final organizationRemoteDatasourceProvider = Provider<OrganizationRemoteDatasource>(
  (ref) {
    final client = ref.watch(organizationHttpClientProvider);
    return OrganizationRemoteDatasource(client: client);
  },
);

final organizationRepositoryProvider = Provider<OrganizationRepository>((ref) {
  final remote = ref.watch(organizationRemoteDatasourceProvider);
  final tokenProvider = ref.watch(organizationTokenProvider);
  return OrganizationRepositoryImpl(remote: remote, tokenProvider: tokenProvider);
});

class _AuthLocalTokenProvider implements TokenProvider {
  final AuthLocalDataSource _authLocal;

  _AuthLocalTokenProvider(this._authLocal);

  @override
  Future<String?> getToken() => _authLocal.getToken();
}
