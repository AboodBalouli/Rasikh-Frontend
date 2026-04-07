import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/features/organization/data/datasources/seller_product_remote_datasource.dart';
import 'package:flutter_application_1/features/organization/data/repositories/seller_product_repository_impl.dart';
import 'package:flutter_application_1/features/organization/domain/entities/product_rating.dart';
import 'package:flutter_application_1/features/organization/domain/entities/seller_metrics.dart';
import 'package:flutter_application_1/features/organization/domain/entities/seller_product.dart';
import 'package:flutter_application_1/features/organization/domain/repositories/seller_product_repository.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/get_my_products_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/get_my_product_by_id_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/create_product_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/update_product_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/delete_product_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/upload_product_images_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/rate_product_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/delete_product_rating_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/get_product_ratings_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/get_products_by_seller_id_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/get_seller_metrics_usecase.dart';
import 'package:flutter_application_1/features/organization/domain/usecases/restore_product_usecase.dart';

/// Re-export the admin dashboard controller provider for convenience.
/// This file serves as the central point for all admin-related providers.

// Re-export the main admin dashboard controller provider
export '../controllers/admin_dashboard_controller.dart'
    show adminDashboardControllerProvider, AdminDashboardState;

// ============================================================================
// Seller Product Infrastructure Providers
// ============================================================================

/// HTTP Client for seller product API
final sellerProductHttpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

/// Token provider for seller product API
final sellerProductTokenProvider = Provider<TokenProvider>((ref) {
  final authLocal = AuthLocalDataSource();
  return _AuthLocalTokenProvider(authLocal);
});

/// Remote datasource for seller product operations
final sellerProductRemoteDatasourceProvider =
    Provider<SellerProductRemoteDatasource>((ref) {
      final client = ref.watch(sellerProductHttpClientProvider);
      return SellerProductRemoteDatasource(client: client);
    });

/// Repository for seller product operations
final sellerProductRepositoryProvider = Provider<SellerProductRepository>((
  ref,
) {
  final remote = ref.watch(sellerProductRemoteDatasourceProvider);
  final tokenProvider = ref.watch(sellerProductTokenProvider);
  return SellerProductRepositoryImpl(
    remote: remote,
    tokenProvider: tokenProvider,
  );
});

// ============================================================================
// Use Case Providers
// ============================================================================

/// Use case to get all products for the current seller
final getMyProductsUseCaseProvider = Provider<GetMyProductsUseCase>((ref) {
  final repo = ref.watch(sellerProductRepositoryProvider);
  return GetMyProductsUseCase(repo);
});

/// Use case to get a specific product by ID
final getMyProductByIdUseCaseProvider = Provider<GetMyProductByIdUseCase>((
  ref,
) {
  final repo = ref.watch(sellerProductRepositoryProvider);
  return GetMyProductByIdUseCase(repo);
});

/// Use case to create a new product
final createProductUseCaseProvider = Provider<CreateProductUseCase>((ref) {
  final repo = ref.watch(sellerProductRepositoryProvider);
  return CreateProductUseCase(repo);
});

/// Use case to update an existing product
final updateProductUseCaseProvider = Provider<UpdateProductUseCase>((ref) {
  final repo = ref.watch(sellerProductRepositoryProvider);
  return UpdateProductUseCase(repo);
});

/// Use case to delete (soft-delete) a product
final deleteProductUseCaseProvider = Provider<DeleteProductUseCase>((ref) {
  final repo = ref.watch(sellerProductRepositoryProvider);
  return DeleteProductUseCase(repo);
});

/// Use case to restore a soft-deleted product
final restoreProductUseCaseProvider = Provider<RestoreProductUseCase>((ref) {
  final repo = ref.watch(sellerProductRepositoryProvider);
  return RestoreProductUseCase(repo);
});

/// Use case to upload images for a product
final uploadProductImagesUseCaseProvider = Provider<UploadProductImagesUseCase>(
  (ref) {
    final repo = ref.watch(sellerProductRepositoryProvider);
    return UploadProductImagesUseCase(repo);
  },
);

/// Use case to rate a product
final rateProductUseCaseProvider = Provider<RateProductUseCase>((ref) {
  final repo = ref.watch(sellerProductRepositoryProvider);
  return RateProductUseCase(repo);
});

/// Use case to delete a product rating
final deleteProductRatingUseCaseProvider = Provider<DeleteProductRatingUseCase>(
  (ref) {
    final repo = ref.watch(sellerProductRepositoryProvider);
    return DeleteProductRatingUseCase(repo);
  },
);

/// Use case to get all ratings for a product
final getProductRatingsUseCaseProvider = Provider<GetProductRatingsUseCase>((
  ref,
) {
  final repo = ref.watch(sellerProductRepositoryProvider);
  return GetProductRatingsUseCase(repo);
});

/// Use case to get products by seller ID (public)
final getProductsBySellerIdUseCaseProvider =
    Provider<GetProductsBySellerIdUseCase>((ref) {
      final repo = ref.watch(sellerProductRepositoryProvider);
      return GetProductsBySellerIdUseCase(repo);
    });

/// Use case to get seller metrics/dashboard
final getSellerMetricsUseCaseProvider = Provider<GetSellerMetricsUseCase>((
  ref,
) {
  final repo = ref.watch(sellerProductRepositoryProvider);
  return GetSellerMetricsUseCase(repo);
});

// ============================================================================
// Data Providers (FutureProvider for fetching data)
// ============================================================================

/// Provider for product ratings by product ID
final productRatingsProvider = FutureProvider.family<List<ProductRating>, int>((
  ref,
  productId,
) {
  final usecase = ref.watch(getProductRatingsUseCaseProvider);
  return usecase(productId);
});

/// Provider for products by seller ID (public)
final productsBySellerIdProvider =
    FutureProvider.family<List<SellerProduct>, String>((ref, sellerId) {
      final usecase = ref.watch(getProductsBySellerIdUseCaseProvider);
      return usecase(sellerId);
    });

/// Provider for seller metrics
final sellerMetricsProvider = FutureProvider<SellerMetrics>((ref) {
  final usecase = ref.watch(getSellerMetricsUseCaseProvider);
  return usecase();
});

// Note: updateOrgContactUseCaseProvider is already defined in organization_provider.dart

// ============================================================================
// Legacy/Compatibility Providers
// ============================================================================

/// Provider to check if current user has admin access.
/// In a real implementation, this would check user roles from auth state.
final hasAdminAccessProvider = Provider<bool>((ref) {
  // For demo purposes, always return true
  // In production, check user roles/permissions
  return true;
});

/// Provider for the currently selected product ID (for editing).
final selectedProductIdProvider = StateProvider<int?>((ref) => null);

// ============================================================================
// Helper Classes
// ============================================================================

class _AuthLocalTokenProvider implements TokenProvider {
  final AuthLocalDataSource _authLocal;

  _AuthLocalTokenProvider(this._authLocal);

  @override
  Future<String?> getToken() => _authLocal.getToken();
}
