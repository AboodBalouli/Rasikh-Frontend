import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/seller_product.dart';
import '../controllers/admin_dashboard_controller.dart';

/// Maximum number of images allowed per product
const int kMaxProductImages = 5;

/// State for the add/edit product form with multi-image support
class AddEditProductFormState {
  const AddEditProductFormState({
    this.name = '',
    this.price = '',
    this.description = '',
    this.existingImageUrls = const [],
    this.newImageBytesList = const [],
    this.nameError,
    this.priceError,
    this.descriptionError,
    this.isSaving = false,
    this.isInitialized = false,
    this.error,
  });

  final String name;
  final String price;
  final String description;

  /// URLs of existing images from the server
  final List<String> existingImageUrls;

  /// Bytes of newly selected images (not yet uploaded)
  final List<Uint8List> newImageBytesList;

  final String? nameError;
  final String? priceError;
  final String? descriptionError;
  final bool isSaving;
  final bool isInitialized;
  final String? error;

  /// Total number of images (existing + new)
  int get totalImageCount =>
      existingImageUrls.length + newImageBytesList.length;

  /// Whether we have at least one image
  bool get hasImage => totalImageCount > 0;

  /// Whether we can add more images
  bool get canAddMoreImages => totalImageCount < kMaxProductImages;

  /// For backwards compatibility - returns first existing image URL
  String get existingImageUrl =>
      existingImageUrls.isNotEmpty ? existingImageUrls.first : '';

  /// For backwards compatibility - returns first new image bytes
  Uint8List? get newImageBytes =>
      newImageBytesList.isNotEmpty ? newImageBytesList.first : null;

  AddEditProductFormState copyWith({
    String? name,
    String? price,
    String? description,
    List<String>? existingImageUrls,
    List<Uint8List>? newImageBytesList,
    String? nameError,
    bool clearNameError = false,
    String? priceError,
    bool clearPriceError = false,
    String? descriptionError,
    bool clearDescriptionError = false,
    bool? isSaving,
    bool? isInitialized,
    String? error,
    bool clearError = false,
  }) {
    return AddEditProductFormState(
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      existingImageUrls: existingImageUrls ?? this.existingImageUrls,
      newImageBytesList: newImageBytesList ?? this.newImageBytesList,
      nameError: clearNameError ? null : (nameError ?? this.nameError),
      priceError: clearPriceError ? null : (priceError ?? this.priceError),
      descriptionError: clearDescriptionError
          ? null
          : (descriptionError ?? this.descriptionError),
      isSaving: isSaving ?? this.isSaving,
      isInitialized: isInitialized ?? this.isInitialized,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Controller for the add/edit product form with multi-image support
class AddEditProductFormController
    extends StateNotifier<AddEditProductFormState> {
  AddEditProductFormController(this._ref, this._productId)
    : super(const AddEditProductFormState()) {
    _initializeFromProduct();
  }

  final Ref _ref;
  final String? _productId;

  bool get isEditMode => _productId != null;
  int? get productIdInt =>
      _productId != null ? int.tryParse(_productId!) : null;

  void _initializeFromProduct() {
    if (_productId != null) {
      final intId = int.tryParse(_productId!);
      if (intId != null) {
        final dashboardState = _ref.read(adminDashboardControllerProvider);
        final product = dashboardState.products
            .where((p) => p.id == intId)
            .firstOrNull;
        if (product != null) {
          state = AddEditProductFormState(
            name: product.name,
            price: product.price.toStringAsFixed(0),
            description: product.description,
            existingImageUrls: product.imagePaths,
            isInitialized: true,
          );
        }
      }
    }
  }

  void setName(String value) {
    if (value.trim().isEmpty) {
      state = state.copyWith(name: value, nameError: 'هذا الحقل مطلوب');
    } else {
      state = state.copyWith(name: value, clearNameError: true);
    }
  }

  void setPrice(String value) {
    if (value.trim().isEmpty) {
      state = state.copyWith(price: value, priceError: 'هذا الحقل مطلوب');
    } else {
      final priceVal = double.tryParse(value.trim());
      if (priceVal == null || priceVal <= 0) {
        state = state.copyWith(price: value, priceError: 'يرجى إدخال سعر صحيح');
      } else {
        state = state.copyWith(price: value, clearPriceError: true);
      }
    }
  }

  void setDescription(String value) {
    if (value.trim().isEmpty) {
      state = state.copyWith(
        description: value,
        descriptionError: 'هذا الحقل مطلوب',
      );
    } else {
      state = state.copyWith(description: value, clearDescriptionError: true);
    }
  }

  /// Add a new image (from gallery/camera)
  void addImage(Uint8List bytes) {
    if (!state.canAddMoreImages) return;
    state = state.copyWith(
      newImageBytesList: [...state.newImageBytesList, bytes],
    );
  }

  /// Add multiple images at once (from multi-image picker)
  void addImages(List<Uint8List> bytesList) {
    if (!state.canAddMoreImages) return;
    final availableSlots = kMaxProductImages - state.totalImageCount;
    final imagesToAdd = bytesList.take(availableSlots).toList();
    state = state.copyWith(
      newImageBytesList: [...state.newImageBytesList, ...imagesToAdd],
    );
  }

  /// Remove a new image by index
  void removeNewImage(int index) {
    if (index < 0 || index >= state.newImageBytesList.length) return;
    final newList = List<Uint8List>.from(state.newImageBytesList);
    newList.removeAt(index);
    state = state.copyWith(newImageBytesList: newList);
  }

  /// Remove an existing image by index
  void removeExistingImage(int index) {
    if (index < 0 || index >= state.existingImageUrls.length) return;
    final newList = List<String>.from(state.existingImageUrls);
    newList.removeAt(index);
    state = state.copyWith(existingImageUrls: newList);
  }

  /// Legacy: Set single image (replaces all new images)
  void setImage(Uint8List? bytes) {
    if (bytes != null) {
      state = state.copyWith(newImageBytesList: [bytes]);
    } else {
      state = state.copyWith(newImageBytesList: []);
    }
  }

  /// Initialize from a product (for edit mode after screen load)
  void initializeFromProduct(SellerProduct product) {
    if (state.isInitialized) return;
    state = AddEditProductFormState(
      name: product.name,
      price: product.price.toStringAsFixed(0),
      description: product.description,
      existingImageUrls: product.imagePaths,
      isInitialized: true,
    );
  }

  /// Validate all fields
  bool validate() {
    bool hasError = false;

    if (state.name.trim().isEmpty) {
      state = state.copyWith(nameError: 'هذا الحقل مطلوب');
      hasError = true;
    }

    if (state.price.trim().isEmpty) {
      state = state.copyWith(priceError: 'هذا الحقل مطلوب');
      hasError = true;
    } else {
      final priceVal = double.tryParse(state.price.trim());
      if (priceVal == null || priceVal <= 0) {
        state = state.copyWith(priceError: 'يرجى إدخال سعر صحيح');
        hasError = true;
      }
    }

    if (state.description.trim().isEmpty) {
      state = state.copyWith(descriptionError: 'هذا الحقل مطلوب');
      hasError = true;
    }

    return !hasError;
  }

  /// Save the product (create or update)
  Future<bool> save() async {
    if (state.isSaving) return false;
    if (!validate()) return false;

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final controller = _ref.read(adminDashboardControllerProvider.notifier);
      final price = double.parse(state.price.trim());

      if (isEditMode && productIdInt != null) {
        // Update existing product
        await controller.updateProduct(
          productId: productIdInt!,
          name: state.name.trim(),
          description: state.description.trim(),
          price: price,
          newImageBytes: state.newImageBytesList.isNotEmpty
              ? state.newImageBytesList
              : null,
        );
      } else {
        // Create new product
        await controller.addProduct(
          name: state.name.trim(),
          description: state.description.trim(),
          price: price,
          imageBytes: state.newImageBytesList.isNotEmpty
              ? state.newImageBytesList
              : null,
        );
      }

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }
}

/// Provider for the add/edit product form controller
/// Pass productId as family parameter (null for add mode, productId string for edit mode)
final addEditProductFormControllerProvider = StateNotifierProvider.autoDispose
    .family<AddEditProductFormController, AddEditProductFormState, String?>(
      (ref, productId) => AddEditProductFormController(ref, productId),
    );
