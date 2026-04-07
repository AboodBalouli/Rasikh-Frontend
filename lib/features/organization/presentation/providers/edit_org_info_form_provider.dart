import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../controllers/admin_dashboard_controller.dart';
import 'organization_provider.dart';

/// State for the edit organization info form
class EditOrgInfoFormState {
  const EditOrgInfoFormState({
    this.phone = '',
    this.description = '',
    this.coverImageUrl = '',
    this.newImageBytes,
    this.phoneError,
    this.descriptionError,
    this.isSaving = false,
    this.isInitialized = false,
    this.error,
  });

  final String phone;
  final String description;
  final String coverImageUrl;
  final Uint8List? newImageBytes;
  final String? phoneError;
  final String? descriptionError;
  final bool isSaving;
  final bool isInitialized;
  final String? error;

  EditOrgInfoFormState copyWith({
    String? phone,
    String? description,
    String? coverImageUrl,
    Uint8List? newImageBytes,
    bool clearNewImage = false,
    String? phoneError,
    bool clearPhoneError = false,
    String? descriptionError,
    bool clearDescriptionError = false,
    bool? isSaving,
    bool? isInitialized,
    String? error,
    bool clearError = false,
  }) {
    return EditOrgInfoFormState(
      phone: phone ?? this.phone,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      newImageBytes: clearNewImage
          ? null
          : (newImageBytes ?? this.newImageBytes),
      phoneError: clearPhoneError ? null : (phoneError ?? this.phoneError),
      descriptionError: clearDescriptionError
          ? null
          : (descriptionError ?? this.descriptionError),
      isSaving: isSaving ?? this.isSaving,
      isInitialized: isInitialized ?? this.isInitialized,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Controller for the edit organization info form
class EditOrgInfoFormController extends StateNotifier<EditOrgInfoFormState> {
  EditOrgInfoFormController(this._ref) : super(const EditOrgInfoFormState()) {
    _initializeFromDashboard();
  }

  final Ref _ref;

  void _initializeFromDashboard() {
    final dashboardState = _ref.read(adminDashboardControllerProvider);
    final info = dashboardState.organizationInfo;

    state = EditOrgInfoFormState(
      phone: info.phone,
      description: info.description,
      coverImageUrl: info.coverImageUrl,
      isInitialized: true,
    );
  }

  void setPhone(String value) {
    final trimmed = value.trim();
    String? error;

    if (trimmed.isEmpty) {
      error = 'هذا الحقل مطلوب';
    } else if (!RegExp(r'^0(77|78|79)').hasMatch(trimmed)) {
      error = 'يجب أن يبدأ الرقم بـ 077 أو 078 أو 079';
    } else if (trimmed.length == 10 &&
        !RegExp(r'^0(77|78|79)\d{7}$').hasMatch(trimmed)) {
      error = 'يجب أن يبدأ الرقم بـ 077 أو 078 أو 079 ويتكون من 10 أرقام';
    }

    if (error != null) {
      state = state.copyWith(phone: value, phoneError: error);
    } else {
      state = state.copyWith(phone: value, clearPhoneError: true);
    }
  }

  void setDescription(String value) {
    state = state.copyWith(description: value, clearDescriptionError: true);
  }

  void setImage(Uint8List? bytes) {
    if (bytes != null) {
      state = state.copyWith(newImageBytes: bytes);
    } else {
      state = state.copyWith(clearNewImage: true);
    }
  }

  /// Validate all fields
  bool validate() {
    bool hasError = false;

    if (state.phone.trim().isEmpty) {
      state = state.copyWith(phoneError: 'هذا الحقل مطلوب');
      hasError = true;
    } else if (!RegExp(r'^0(77|78|79)\d{7}$').hasMatch(state.phone.trim())) {
      state = state.copyWith(
        phoneError: 'يجب أن يبدأ الرقم بـ 077 أو 078 أو 079 ويتكون من 10 أرقام',
      );
      hasError = true;
    }

    if (state.description.trim().isEmpty) {
      state = state.copyWith(descriptionError: 'هذا الحقل مطلوب');
      hasError = true;
    }

    return !hasError;
  }

  /// Save the organization info
  Future<bool> save() async {
    if (state.isSaving) return false;
    if (!validate()) return false;

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final currentInfo = _ref
          .read(adminDashboardControllerProvider)
          .organizationInfo;

      // Call the backend API to update org contact info
      final updateOrgContactUseCase = _ref.read(
        updateOrgContactUseCaseProvider,
      );
      await updateOrgContactUseCase(
        phone: state.phone.trim(),
        description: state.description.trim(),
        coverImageBytes: state.newImageBytes,
      );

      // If new image was selected, upload it
      String? newImagePath;
      if (state.newImageBytes != null && currentInfo.ownerUserId != null) {
        final uploadProfilePictureUseCase = _ref.read(
          uploadProfilePictureUseCaseProvider,
        );
        newImagePath = await uploadProfilePictureUseCase(
          userId: currentInfo.ownerUserId!,
          fileBytes: state.newImageBytes!,
        );
      }

      // Update the local state for immediate UI feedback
      final controller = _ref.read(adminDashboardControllerProvider.notifier);
      controller.updateOrganizationInfo(
        currentInfo.copyWith(
          phone: state.phone.trim(),
          description: state.description.trim(),
          coverImageUrl: newImagePath ?? state.coverImageUrl,
        ),
      );

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }
}

/// Provider for the edit organization info form controller
final editOrgInfoFormControllerProvider =
    StateNotifierProvider.autoDispose<
      EditOrgInfoFormController,
      EditOrgInfoFormState
    >((ref) => EditOrgInfoFormController(ref));
