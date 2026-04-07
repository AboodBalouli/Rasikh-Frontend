import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:flutter_application_1/app/dependency_injection/riverpod_providers.dart';
import 'package:flutter_application_1/features/user_profile/data/datasources/user_profile_remote_datasource.dart';
import 'package:flutter_application_1/features/user_profile/data/repositories/profile_user_repository.dart';
import 'package:flutter_application_1/features/user_profile/data/repositories/user_profile_repository_impl.dart';
import 'package:flutter_application_1/features/user_profile/domain/repositories/user_profile_repository.dart';
import 'package:flutter_application_1/features/user_profile/domain/repositories/user_repository.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/get_current_user.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/get_my_profile.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/get_user_by_id.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/ensure_my_profile.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/update_user.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/update_seller_category.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/update_store_info.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/upload_profile_picture.dart';
import 'package:flutter_application_1/features/user_profile/domain/usecases/upload_profile_image.dart';
import 'package:flutter_application_1/features/user_profile/presentation/controllers/user_controller.dart';
import 'package:flutter_application_1/features/user_profile/presentation/controllers/store_settings_controller.dart';

final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((
  ref,
) {
  final client = ref.watch(httpClientProvider);
  final token = ref.watch(tokenProvider);

  return ProfileRemoteDatasource(client: client, tokenProvider: token);
});

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final remote = ref.watch(profileRemoteDatasourceProvider);
  return UserProfileRepositoryImpl(remote);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final profileRepository = ref.watch(userProfileRepositoryProvider);
  return ProfileUserRepository(profileRepository);
});

final getCurrentUserProvider = Provider<GetCurrentUser>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return GetCurrentUser(repo);
});

final getUserByIdProvider = Provider<GetUserById>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return GetUserById(repo);
});

final updateUserProvider = Provider<UpdateUser>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UpdateUser(repo);
});

final uploadProfileImageProvider = Provider<UploadProfileImage>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UploadProfileImage(repo);
});

final updateSellerCategoryProvider = Provider<UpdateSellerCategory>((ref) {
  final repo = ref.watch(userProfileRepositoryProvider);
  return UpdateSellerCategory(repo);
});

final getMyProfileProvider = Provider<GetMyProfile>((ref) {
  final repo = ref.watch(userProfileRepositoryProvider);
  return GetMyProfile(repo);
});

final ensureMyProfileProvider = Provider<EnsureMyProfile>((ref) {
  final repo = ref.watch(userProfileRepositoryProvider);
  return EnsureMyProfile(repo);
});

final updateStoreInfoProvider = Provider<UpdateStoreInfo>((ref) {
  final repo = ref.watch(userProfileRepositoryProvider);
  return UpdateStoreInfo(repo);
});

final uploadProfilePictureProvider = Provider<UploadProfilePicture>((ref) {
  final repo = ref.watch(userProfileRepositoryProvider);
  return UploadProfilePicture(repo);
});

final storeSettingsControllerProvider =
    ChangeNotifierProvider<StoreSettingsController>((ref) {
      final controller = StoreSettingsController(
        getMyProfile: ref.watch(getMyProfileProvider),
        ensureMyProfile: ref.watch(ensureMyProfileProvider),
        updateStoreInfo: ref.watch(updateStoreInfoProvider),
        uploadProfilePicture: ref.watch(uploadProfilePictureProvider),
      );

      return controller;
    });

final userControllerProvider = ChangeNotifierProvider<UserController>((ref) {
  final getCurrentUser = ref.watch(getCurrentUserProvider);
  final getUserById = ref.watch(getUserByIdProvider);
  final updateUser = ref.watch(updateUserProvider);
  final uploadProfileImage = ref.watch(uploadProfileImageProvider);

  return UserController(
    getCurrentUser: getCurrentUser,
    getUserById: getUserById,
    updateUser: updateUser,
    uploadProfileImage: uploadProfileImage,
  );
});
