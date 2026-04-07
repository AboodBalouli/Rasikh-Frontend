import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/app/dependency_injection/seller_dependency_injection.dart';
import 'package:flutter_application_1/features/seller_page/domain/entities/seller_profile.dart';
import 'package:flutter_application_1/features/seller_page/domain/entities/update_store_info.dart';
import 'package:flutter_riverpod/legacy.dart';

class SellerProfileState {
  final SellerProfile? profile;
  final bool isLoading;
  final bool isUpdating;
  final String? error;

  const SellerProfileState({
    this.profile,
    this.isLoading = false,
    this.isUpdating = false,
    this.error,
  });

  SellerProfileState copyWith({
    SellerProfile? profile,
    bool? isLoading,
    bool? isUpdating,
    String? error,
  }) {
    return SellerProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error,
    );
  }
}

final sellerProfileControllerProvider =
    StateNotifierProvider<SellerProfileController, SellerProfileState>((ref) {
      return SellerProfileController(ref);
    });

class SellerProfileController extends StateNotifier<SellerProfileState> {
  final Ref ref;

  SellerProfileController(this.ref) : super(const SellerProfileState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final usecase = ref.read(getMyProfileUseCaseProvider);
      final profile = await usecase();
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (_) {
      // Try ensure and retry
      try {
        final ensure = ref.read(ensureMyProfileUseCaseProvider);
        final profile = await ensure();
        state = state.copyWith(profile: profile, isLoading: false);
      } catch (e) {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load profile',
        );
      }
    }
  }

  Future<void> updateStore(UpdateStoreInfo info) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      final usecase = ref.read(updateMyStoreUseCaseProvider);
      final profile = await usecase(info);
      state = state.copyWith(profile: profile, isUpdating: false);
    } catch (e) {
      state = state.copyWith(isUpdating: false, error: e.toString());
    }
  }

  Future<void> updateCategory(int categoryId) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      final usecase = ref.read(updateSellerCategoryUseCaseProvider);
      final profile = await usecase(categoryId);
      state = state.copyWith(profile: profile, isUpdating: false);
    } catch (e) {
      state = state.copyWith(isUpdating: false, error: e.toString());
    }
  }
}
