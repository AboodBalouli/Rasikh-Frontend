import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/features/wishlists/data/datasources/wishlist_remote_datasource.dart';
import 'package:flutter_application_1/features/wishlists/data/repositories/wishlist_repository_impl.dart';
import 'package:flutter_application_1/features/wishlists/domain/repositories/wishlist_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final wishlistHttpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final wishlistTokenProvider = Provider<TokenProvider>((ref) {
  final authLocal = AuthLocalDataSource();
  return _AuthLocalTokenProvider(authLocal);
});

final wishlistRemoteDataSourceProvider = Provider<WishlistRemoteDatasource>((
  ref,
) {
  final client = ref.watch(wishlistHttpClientProvider);
  return WishlistRemoteDatasource(client: client);
});

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  final remote = ref.watch(wishlistRemoteDataSourceProvider);
  final tokenProvider = ref.watch(wishlistTokenProvider);
  return WishlistRepositoryImpl(remote: remote, tokenProvider: tokenProvider);
});

class _AuthLocalTokenProvider implements TokenProvider {
  final AuthLocalDataSource _authLocal;

  _AuthLocalTokenProvider(this._authLocal);

  @override
  Future<String?> getToken() => _authLocal.getToken();
}
