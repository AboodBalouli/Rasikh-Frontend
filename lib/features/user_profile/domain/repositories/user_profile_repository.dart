// lib/src/features/profile/domain/repositories/profile_repository.dart
import 'package:flutter_application_1/features/user_profile/domain/entities/profile.dart';
import 'package:flutter_application_1/features/user_profile/domain/entities/store_info.dart';
import 'package:flutter/foundation.dart' show Uint8List;

abstract class UserProfileRepository {
  Future<Profile> getMyProfile();

  /// Usually called once after login or when opening the profile page
  Future<Profile> ensureMyProfile();

  Future<Profile> updateStoreInfo(StoreInfo storeInfo);

  /// SELLER-only: PUT `/profile/me/seller-category`
  Future<Profile> updateSellerCategory({required int categoryId});

  Future<String> uploadProfilePicture({
    required int userId,
    String? filePath,
    Uint8List? bytes,
    String? filename,
  });

  Future<void> deleteProfilePicture({required int userId});
}
