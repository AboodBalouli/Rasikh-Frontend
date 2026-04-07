import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/features/seller_page/data/datasources/seller_remote_datasource.dart';
import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/features/seller_page/data/repositories/seller_repository_impl.dart';
import 'package:flutter_application_1/features/seller_page/domain/repositories/seller_repository.dart';
import 'package:flutter_application_1/features/seller_page/domain/usecases/ensure_my_profile_usecase.dart';
import 'package:flutter_application_1/features/seller_page/domain/usecases/get_my_products_usecase.dart';
import 'package:flutter_application_1/features/seller_page/domain/usecases/get_my_profile_usecase.dart';
import 'package:flutter_application_1/features/seller_page/domain/usecases/request_seller_role_usecase.dart';
import 'package:flutter_application_1/features/seller_page/domain/usecases/update_my_store_usecase.dart';
import 'package:flutter_application_1/features/seller_page/domain/usecases/update_seller_category_usecase.dart';
import 'package:flutter_application_1/app/dependency_injection/auth_dependency_injection.dart'; // import for accessing auth client or token providers if available? No, authHttpClientProvider is there.

// Reuse the global auth client if appropriate, or create new.
// Using authHttpClientProvider from auth_dependency_injection which is just http.Client
final sellerRemoteDataSourceProvider = Provider<SellerRemoteDataSource>((ref) {
  final client = ref.watch(authHttpClientProvider);
  return SellerRemoteDataSource(client: client);
});

final sellerTokenProvider = Provider<TokenProvider>((ref) {
  final authLocal = AuthLocalDataSource();
  return _AuthLocalTokenProvider(authLocal);
});

final sellerRepositoryProvider = Provider<SellerRepository>((ref) {
  final remote = ref.watch(sellerRemoteDataSourceProvider);
  final tokenProvider = ref.watch(sellerTokenProvider);
  return SellerRepositoryImpl(
    remoteDataSource: remote,
    tokenProvider: tokenProvider,
  );
});

final requestSellerRoleUseCaseProvider = Provider<RequestSellerRoleUseCase>((
  ref,
) {
  final repo = ref.watch(sellerRepositoryProvider);
  return RequestSellerRoleUseCase(repo);
});

final getMyProfileUseCaseProvider = Provider<GetMyProfileUseCase>((ref) {
  final repo = ref.watch(sellerRepositoryProvider);
  return GetMyProfileUseCase(repo);
});

final ensureMyProfileUseCaseProvider = Provider<EnsureMyProfileUseCase>((ref) {
  final repo = ref.watch(sellerRepositoryProvider);
  return EnsureMyProfileUseCase(repo);
});

final updateMyStoreUseCaseProvider = Provider<UpdateMyStoreUseCase>((ref) {
  final repo = ref.watch(sellerRepositoryProvider);
  return UpdateMyStoreUseCase(repo);
});

final updateSellerCategoryUseCaseProvider = Provider<UpdateSellerCategoryUseCase>(
  (ref) {
    final repo = ref.watch(sellerRepositoryProvider);
    return UpdateSellerCategoryUseCase(repo);
  },
);

final getMyProductsUseCaseProvider = Provider<GetMyProductsUseCase>((ref) {
  final repo = ref.watch(sellerRepositoryProvider);
  return GetMyProductsUseCase(repo);
});

class _AuthLocalTokenProvider implements TokenProvider {
  final AuthLocalDataSource _authLocal;

  _AuthLocalTokenProvider(this._authLocal);

  @override
  Future<String?> getToken() => _authLocal.getToken();
}
