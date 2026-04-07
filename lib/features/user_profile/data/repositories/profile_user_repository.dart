import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/features/user_profile/domain/entities/profile.dart';
import 'package:flutter_application_1/features/user_profile/domain/entities/store_info.dart';
import 'package:flutter_application_1/features/user_profile/domain/entities/user.dart';
import 'package:flutter_application_1/features/user_profile/domain/repositories/user_profile_repository.dart';
import 'package:flutter_application_1/features/user_profile/domain/repositories/user_repository.dart';

class ProfileUserRepository implements UserRepository {
  final UserProfileRepository _profileRepository;

  ProfileUserRepository(this._profileRepository);

  static final DateTime _unknownCreatedAt = DateTime.fromMillisecondsSinceEpoch(
    0,
    isUtc: true,
  );

  String _toAbsoluteUrl(String pathOrUrl) {
    if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
      return pathOrUrl;
    }
    if (pathOrUrl.startsWith('/')) {
      return '${AppConfig.apiBaseUrl}$pathOrUrl';
    }
    return '${AppConfig.apiBaseUrl}/$pathOrUrl';
  }

  User _mapProfileToUser(Profile profile) {
    final store = profile.store;
    return User(
      id: profile.userId.toString(),
      name: '${profile.firstName} ${profile.lastName}'.trim(),
      email: profile.email,
      phone: store?.phone ?? '',
      profileImage: profile.profilePicturePath == null
          ? ''
          : _toAbsoluteUrl(profile.profilePicturePath!),
      address: store?.address ?? '',
      city: '',
      country: '',
      createdAt: _unknownCreatedAt,
      isVerified: false,
    );
  }

  @override
  Future<User> getCurrentUser() async {
    // Safe for older users without a profile row.
    final profile = await _profileRepository.ensureMyProfile();
    return _mapProfileToUser(profile);
  }

  @override
  Future<User> getUserById(String id) async {
    final current = await getCurrentUser();
    if (current.id == id) return current;
    throw UnsupportedError('Profile API supports only current user');
  }

  @override
  Future<User> updateUser(User user) async {
    // Profile API only supports store info partial updates.
    // We update the store fields we can, and return merged user locally.
    final currentProfile = await _profileRepository.ensureMyProfile();

    final StoreInfo currentStore = currentProfile.store ?? StoreInfo();

    final updatedProfile = await _profileRepository.updateStoreInfo(
      StoreInfo(
        address: user.address.isEmpty ? currentStore.address : user.address,
        phone: user.phone.isEmpty ? currentStore.phone : user.phone,
        workingHours: currentStore.workingHours,
      ),
    );

    return _mapProfileToUser(updatedProfile).copyWith(
      name: user.name,
      email: user.email,
      city: user.city,
      country: user.country,
      isVerified: user.isVerified,
      createdAt: user.createdAt,
    );
  }

  @override
  Future<void> deleteUser(String id) async {
    throw UnsupportedError('Profile API does not support deleting users');
  }

  @override
  Future<String> uploadProfileImage(String userId, String imagePath) async {
    final parsed = int.tryParse(userId);
    if (parsed == null) {
      throw ArgumentError('Invalid userId: $userId');
    }

    final relativePath = await _profileRepository.uploadProfilePicture(
      userId: parsed,
      filePath: imagePath,
    );

    // Backend returns "images/profile/..."; return absolute URL for UI.
    return _toAbsoluteUrl('/$relativePath');
  }
}
