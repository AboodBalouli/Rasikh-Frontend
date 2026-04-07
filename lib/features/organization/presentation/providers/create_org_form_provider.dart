import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/organization_application.dart';
import 'organization_provider.dart';

/// State for the create organization form
class CreateOrgFormState {
  const CreateOrgFormState({
    this.currentStep = 0,
    this.name = '',
    this.description = '',
    this.location = '',
    this.phone = '',
    this.profileImageBytes,
    this.certificateBytes,
    this.proofImages = const [],
    this.profileImageError = false,
    this.isSubmitting = false,
    this.error,
  });

  final int currentStep;
  final String name;
  final String description;
  final String location;
  final String phone;
  final Uint8List? profileImageBytes;
  final Uint8List? certificateBytes;
  final List<Uint8List> proofImages;
  final bool profileImageError;
  final bool isSubmitting;
  final String? error;

  CreateOrgFormState copyWith({
    int? currentStep,
    String? name,
    String? description,
    String? location,
    String? phone,
    Uint8List? profileImageBytes,
    bool clearProfileImage = false,
    Uint8List? certificateBytes,
    bool clearCertificate = false,
    List<Uint8List>? proofImages,
    bool? profileImageError,
    bool? isSubmitting,
    String? error,
    bool clearError = false,
  }) {
    return CreateOrgFormState(
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      profileImageBytes: clearProfileImage
          ? null
          : (profileImageBytes ?? this.profileImageBytes),
      certificateBytes: clearCertificate
          ? null
          : (certificateBytes ?? this.certificateBytes),
      proofImages: proofImages ?? this.proofImages,
      profileImageError: profileImageError ?? this.profileImageError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Controller for the create organization form
class CreateOrgFormController extends StateNotifier<CreateOrgFormState> {
  CreateOrgFormController(this._ref) : super(const CreateOrgFormState());

  final Ref _ref;

  void setName(String value) {
    state = state.copyWith(name: value);
  }

  void setDescription(String value) {
    state = state.copyWith(description: value);
  }

  void setLocation(String value) {
    state = state.copyWith(location: value);
  }

  void setPhone(String value) {
    state = state.copyWith(phone: value);
  }

  void setProfileImage(Uint8List? bytes) {
    state = state.copyWith(
      profileImageBytes: bytes,
      clearProfileImage: bytes == null,
      profileImageError: false,
    );
  }

  void setCertificate(Uint8List? bytes) {
    state = state.copyWith(
      certificateBytes: bytes,
      clearCertificate: bytes == null,
    );
  }

  void addProofImage(Uint8List bytes) {
    if (state.proofImages.length >= 5) return;
    state = state.copyWith(proofImages: [...state.proofImages, bytes]);
  }

  void removeProofImage(int index) {
    if (index < 0 || index >= state.proofImages.length) return;
    final newImages = List<Uint8List>.from(state.proofImages)..removeAt(index);
    state = state.copyWith(proofImages: newImages);
  }

  void setProfileImageError(bool hasError) {
    state = state.copyWith(profileImageError: hasError);
  }

  /// Navigate to next step with validation
  bool nextStep() {
    if (state.currentStep == 0) {
      // Validate step 1
      if (state.profileImageBytes == null) {
        state = state.copyWith(profileImageError: true);
        return false;
      }
      if (state.name.trim().isEmpty ||
          state.description.trim().isEmpty ||
          state.location.trim().isEmpty ||
          state.phone.trim().isEmpty) {
        return false;
      }
      // Validate phone format
      if (!RegExp(r'^0(77|78|79)\d{7}$').hasMatch(state.phone.trim())) {
        return false;
      }
      state = state.copyWith(currentStep: 1, profileImageError: false);
      return true;
    } else if (state.currentStep == 1) {
      // Validate step 2
      if (state.certificateBytes == null) {
        return false;
      }
      if (state.proofImages.length != 5) {
        return false;
      }
      state = state.copyWith(currentStep: 2);
      return true;
    }
    return false;
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  /// Submit the organization application
  Future<bool> submit() async {
    if (state.isSubmitting) return false;

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final application = OrganizationApplication(
        name: state.name.trim(),
        description: state.description.trim(),
        government: state.location.trim(),
        phoneNumber: state.phone.trim(),
        certificateBytes: state.certificateBytes!,
        proofImages: state.proofImages,
        profileImageBytes: state.profileImageBytes,
      );

      final createUseCase = _ref.read(createOrganizationUseCaseProvider);
      await createUseCase(application);

      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return false;
    }
  }

  /// Reset the form to initial state
  void reset() {
    state = const CreateOrgFormState();
  }
}

/// Provider for the create organization form controller
final createOrgFormControllerProvider =
    StateNotifierProvider.autoDispose<
      CreateOrgFormController,
      CreateOrgFormState
    >((ref) => CreateOrgFormController(ref));
