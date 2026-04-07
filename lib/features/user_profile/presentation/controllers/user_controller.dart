import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/user_profile/domain/entities/user.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/get_current_user.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/get_user_by_id.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/update_user.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/upload_profile_image.dart';

class UserController extends ChangeNotifier {
  final GetCurrentUser _getCurrentUser;
  final GetUserById _getUserById;
  final UpdateUser _updateUser;
  final UploadProfileImage _uploadProfileImage;

  UserController({
    required GetCurrentUser getCurrentUser,
    required GetUserById getUserById,
    required UpdateUser updateUser,
    required UploadProfileImage uploadProfileImage,
  }) : _getCurrentUser = getCurrentUser,
       _getUserById = getUserById,
       _updateUser = updateUser,
       _uploadProfileImage = uploadProfileImage;

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUser => _user != null;

  Future<void> fetchCurrentUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _getCurrentUser();
    } catch (e) {
      _error = e.toString();
      _user = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _getUserById(id);
    } catch (e) {
      _error = e.toString();
      _user = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser(User updatedUser) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _updateUser(updatedUser);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> uploadProfileImage(String userId, String imagePath) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final imageUrl = await _uploadProfileImage(userId, imagePath);
      // Update local user with new image URL if it matches the current user
      if (_user != null && _user!.id == userId) {
        _user = _user!.copyWith(profileImage: imageUrl);
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
