import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/seller_product.dart';
import '../../domain/entities/admin_organization_info.dart';
import '../../domain/usecases/get_my_products_usecase.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/restore_product_usecase.dart';
import '../../domain/usecases/upload_product_images_usecase.dart';
import '../../domain/usecases/update_org_contact_usecase.dart';
import '../providers/admin_providers.dart';
import '../providers/organization_provider.dart';

/// State for the admin dashboard.
class AdminDashboardState {
  const AdminDashboardState({
    required this.products,
    required this.organizationInfo,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isSubmitting = false,
    this.error,
    this.currentPage = 0,
    this.hasMorePages = true,
  });

  final List<SellerProduct> products;
  final AdminOrganizationInfo organizationInfo;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isSubmitting;
  final String? error;
  final int currentPage;
  final bool hasMorePages;

  static const int pageSize = 10;

  AdminDashboardState copyWith({
    List<SellerProduct>? products,
    AdminOrganizationInfo? organizationInfo,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isSubmitting,
    String? error,
    int? currentPage,
    bool? hasMorePages,
  }) {
    return AdminDashboardState(
      products: products ?? this.products,
      organizationInfo: organizationInfo ?? this.organizationInfo,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }
}

/// Provider for the admin dashboard controller.
final adminDashboardControllerProvider =
    NotifierProvider<AdminDashboardController, AdminDashboardState>(
      AdminDashboardController.new,
    );

/// Controller for the admin dashboard.
class AdminDashboardController extends Notifier<AdminDashboardState> {
  GetMyProductsUseCase? _getMyProductsUseCase;
  CreateProductUseCase? _createProductUseCase;
  UpdateProductUseCase? _updateProductUseCase;
  DeleteProductUseCase? _deleteProductUseCase;
  RestoreProductUseCase? _restoreProductUseCase;
  UploadProductImagesUseCase? _uploadProductImagesUseCase;
  UpdateOrgContactUseCase? _updateOrgContactUseCase;

  bool _isInitialized = false;

  @override
  AdminDashboardState build() {
    // Initialize use cases from providers using ref.read (not watch)
    // to avoid rebuilds when these providers change
    _getMyProductsUseCase = ref.read(getMyProductsUseCaseProvider);
    _createProductUseCase = ref.read(createProductUseCaseProvider);
    _updateProductUseCase = ref.read(updateProductUseCaseProvider);
    _deleteProductUseCase = ref.read(deleteProductUseCaseProvider);
    _restoreProductUseCase = ref.read(restoreProductUseCaseProvider);
    _uploadProductImagesUseCase = ref.read(uploadProductImagesUseCaseProvider);
    _updateOrgContactUseCase = ref.read(updateOrgContactUseCaseProvider);

    // Only load products once on initial build
    if (!_isInitialized) {
      _isInitialized = true;
      Future.microtask(() => _loadProducts());
    }

    return const AdminDashboardState(
      products: [],
      organizationInfo: AdminOrganizationInfo(
        id: '',
        name: '',
        description: '',
        phone: '',
        coverImageUrl: '',
      ),
      isLoading: true,
    );
  }

  /// Load initial products from the backend (page 0)
  Future<void> _loadProducts() async {
    try {
      state = state.copyWith(isLoading: true, error: null, currentPage: 0);
      final products =
          await _getMyProductsUseCase?.call(
            pageNumber: 0,
            pageSize: AdminDashboardState.pageSize,
          ) ??
          [];

      state = state.copyWith(
        products: products,
        isLoading: false,
        currentPage: 0,
        hasMorePages: products.length >= AdminDashboardState.pageSize,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Load more products (next page) for lazy loading / infinite scroll
  Future<void> loadMoreProducts() async {
    if (state.isLoadingMore || !state.hasMorePages) return;

    try {
      state = state.copyWith(isLoadingMore: true, error: null);
      final nextPage = state.currentPage + 1;

      final newProducts =
          await _getMyProductsUseCase?.call(
            pageNumber: nextPage,
            pageSize: AdminDashboardState.pageSize,
          ) ??
          [];

      state = state.copyWith(
        products: [...state.products, ...newProducts],
        isLoadingMore: false,
        currentPage: nextPage,
        hasMorePages: newProducts.length >= AdminDashboardState.pageSize,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  /// Refresh products from backend (reset to page 0)
  Future<void> refreshProducts() async {
    await _loadProducts();
  }

  /// Get product by ID from current state
  SellerProduct? getProductById(int productId) {
    try {
      return state.products.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Add a new product
  Future<SellerProduct?> addProduct({
    required String name,
    required String description,
    required double price,
    List<Uint8List>? imageBytes,
    List<String>? tags,
  }) async {
    try {
      state = state.copyWith(isSubmitting: true, error: null);

      SellerProduct newProduct;
      if (imageBytes != null && imageBytes.isNotEmpty) {
        newProduct = await _createProductUseCase!.withImages(
          name: name,
          description: description,
          price: price,
          imageBytes: imageBytes,
          tags: tags,
        );
      } else {
        newProduct = await _createProductUseCase!.call(
          name: name,
          description: description,
          price: price,
          tags: tags,
        );
      }

      // Add to local state
      state = state.copyWith(
        products: [...state.products, newProduct],
        isSubmitting: false,
      );

      return newProduct;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      rethrow;
    }
  }

  /// Update an existing product
  Future<SellerProduct?> updateProduct({
    required int productId,
    required String name,
    required String description,
    required double price,
    List<Uint8List>? newImageBytes,
    List<String>? tags,
  }) async {
    try {
      state = state.copyWith(isSubmitting: true, error: null);

      // Update product data
      final updatedProduct = await _updateProductUseCase!.call(
        productId: productId,
        name: name,
        description: description,
        price: price,
        tags: tags,
      );

      // Upload new images if provided
      if (newImageBytes != null && newImageBytes.isNotEmpty) {
        await _uploadProductImagesUseCase!.call(
          productId: productId,
          imageBytes: newImageBytes,
        );
      }

      // Update local state
      final updatedProducts = state.products.map((product) {
        if (product.id == productId) {
          return updatedProduct;
        }
        return product;
      }).toList();

      state = state.copyWith(products: updatedProducts, isSubmitting: false);

      return updatedProduct;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      rethrow;
    }
  }

  /// Delete (soft-delete) a product - hides it
  Future<void> deleteProduct(int productId) async {
    try {
      state = state.copyWith(isSubmitting: true, error: null);

      await _deleteProductUseCase!.call(productId);

      // Update local state - mark as not visible
      final updatedProducts = state.products.map((p) {
        if (p.id == productId) {
          return p.copyWith(isVisible: false);
        }
        return p;
      }).toList();

      state = state.copyWith(products: updatedProducts, isSubmitting: false);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      rethrow;
    }
  }

  /// Restore a soft-deleted product - makes it visible again
  Future<void> restoreProduct(int productId) async {
    try {
      state = state.copyWith(isSubmitting: true, error: null);

      final restoredProduct = await _restoreProductUseCase!.call(productId);

      // Update local state
      final updatedProducts = state.products.map((p) {
        if (p.id == productId) {
          return restoredProduct;
        }
        return p;
      }).toList();

      state = state.copyWith(products: updatedProducts, isSubmitting: false);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      rethrow;
    }
  }

  /// Toggle product visibility (soft-delete if visible, restore if hidden)
  /// Uses the PUT endpoint that automatically toggles the state
  Future<void> toggleProductVisibility(int productId) async {
    try {
      state = state.copyWith(isSubmitting: true, error: null);

      // Call the toggle endpoint (same as deleteProduct which now uses PUT)
      await _deleteProductUseCase!.call(productId);

      // Refresh products to get the updated visibility state from backend
      await refreshProducts();

      state = state.copyWith(isSubmitting: false);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      rethrow;
    }
  }

  /// Update organization info (phone, description)
  Future<void> updateOrganizationContact({
    required String phone,
    required String description,
  }) async {
    try {
      state = state.copyWith(isSubmitting: true, error: null);

      await _updateOrgContactUseCase!.call(
        phone: phone,
        description: description,
      );

      // Update local state
      state = state.copyWith(
        organizationInfo: state.organizationInfo.copyWith(
          phone: phone,
          description: description,
        ),
        isSubmitting: false,
      );
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      rethrow;
    }
  }

  /// Update organization info locally (for UI feedback)
  void updateOrganizationInfo(AdminOrganizationInfo info) {
    state = state.copyWith(organizationInfo: info);
  }
}
