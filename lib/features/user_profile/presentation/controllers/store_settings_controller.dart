import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/features/user_profile/domain/entities/profile.dart';
import 'package:flutter_application_1/features/user_profile/domain/entities/store_info.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/ensure_my_profile.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/get_my_profile.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/update_store_info.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/upload_profile_picture.dart';

class StoreSettingsController extends ChangeNotifier {
  final GetMyProfile _getMyProfile;
  final EnsureMyProfile _ensureMyProfile;
  final UpdateStoreInfo _updateStoreInfo;
  final UploadProfilePicture _uploadProfilePicture;

  StoreSettingsController({
    required GetMyProfile getMyProfile,
    required EnsureMyProfile ensureMyProfile,
    required UpdateStoreInfo updateStoreInfo,
    required UploadProfilePicture uploadProfilePicture,
  }) : _getMyProfile = getMyProfile,
       _ensureMyProfile = ensureMyProfile,
       _updateStoreInfo = updateStoreInfo,
       _uploadProfilePicture = uploadProfilePicture;

  Profile? _profile;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _getMyProfile();
    } catch (_) {
      // Some users may not have a profile row yet.
      try {
        _profile = await _ensureMyProfile();
      } catch (e) {
        _error = e.toString();
        _profile = null;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> save(StoreInfo updated) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _updateStoreInfo(updated);
    } catch (e) {
      _error = e.toString();
    }

    _isSaving = false;
    notifyListeners();
  }

  Future<void> uploadProfilePicture({
    String? filePath,
    Uint8List? bytes,
    String? filename,
  }) async {
    final current = _profile;
    if (current == null) return;

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await _uploadProfilePicture(
        userId: current.userId,
        filePath: filePath,
        bytes: bytes,
        filename: filename,
      );
      // Refresh profile so UI gets the updated profilePicturePath.
      _profile = await _getMyProfile();
    } catch (e) {
      _error = e.toString();
    }

    _isSaving = false;
    notifyListeners();
  }
}
