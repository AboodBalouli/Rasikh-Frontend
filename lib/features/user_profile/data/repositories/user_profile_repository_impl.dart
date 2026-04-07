// lib/src/features/profile/data/repositories/profile_repository_impl.dart
import 'package:flutter/foundation.dart' show Uint8List;

import 'package:flutter_application_1/features/user_profile/data/datasources/user_profile_remote_datasource.dart';
import 'package:flutter_application_1/features/user_profile/domain/entities/seller_category.dart';
import 'package:flutter_application_1/features/user_profile/data/models/store_info_model.dart';
import 'package:flutter_application_1/features/user_profile/domain/entities/profile.dart';
import 'package:flutter_application_1/features/user_profile/domain/entities/store_info.dart';
import 'package:flutter_application_1/features/user_profile/domain/repositories/user_profile_repository.dart';

import '../models/profile_model.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;

  UserProfileRepositoryImpl(this.remoteDatasource);

  Profile _mapProfileModelToEntity(ProfileModel model) {
    return Profile(
      id: model.id,
      userId: model.userId,
      email: model.email,
      firstName: model.firstName,
      lastName: model.lastName,
      walletId: model.walletId,
      walletBalance: model.walletBalance,
      btcAddress: model.btcAddress,
      profilePicturePath: model.profilePicturePath,
      sellerCategory: model.sellerCategory == null
          ? null
          : SellerCategory(
              id: model.sellerCategory!.id,
              name: model.sellerCategory!.name,
            ),
      store: model.store == null
          ? null
          : StoreInfo(
              address: model.store!.address,
              phone: model.store!.phone,
              workingHours: model.store!.workingHours,
              totalSales: model.store!.totalSales,
              storeName: model.store!.storeName,
              description: model.store!.description,
              averageRating: model.store!.averageRating,
              ratingCount: model.store!.ratingCount,
              country: model.store!.country,
              government: model.store!.government,
              themeColor: model.store!.themeColor,
              tags: model.store!.tags,
            ),
    );
  }

  @override
  Future<Profile> getMyProfile() async {
    final response = await remoteDatasource.getMyProfile();
    if (!response.success || response.data == null) {
      throw Exception(response.error?.message ?? 'Failed to load profile');
    }
    return _mapProfileModelToEntity(response.data as ProfileModel);
  }

  @override
  Future<Profile> ensureMyProfile() async {
    final response = await remoteDatasource.ensureMyProfile();
    if (!response.success || response.data == null) {
      throw Exception(response.error?.message ?? 'Failed to ensure profile');
    }
    return _mapProfileModelToEntity(response.data as ProfileModel);
  }

  @override
  Future<Profile> updateStoreInfo(StoreInfo storeInfo) async {
    final model = StoreInfoModel(
      address: storeInfo.address,
      phone: storeInfo.phone,
      workingHours: storeInfo.workingHours,
      storeName: storeInfo.storeName,
      description: storeInfo.description,
      country: storeInfo.country,
      government: storeInfo.government,
      themeColor: storeInfo.themeColor,
      firstName: storeInfo.firstName,
      lastName: storeInfo.lastName,
      tags: storeInfo.tags,
    );

    final response = await remoteDatasource.updateStoreInfo(model);
    if (!response.success || response.data == null) {
      throw Exception(response.error?.message ?? 'Failed to update store info');
    }
    return _mapProfileModelToEntity(response.data as ProfileModel);
  }

  @override
  Future<Profile> updateSellerCategory({required int categoryId}) async {
    final response = await remoteDatasource.updateSellerCategory(
      categoryId: categoryId,
    );
    if (!response.success || response.data == null) {
      throw Exception(response.error?.message ?? 'Failed to update category');
    }
    return _mapProfileModelToEntity(response.data as ProfileModel);
  }

  @override
  Future<String> uploadProfilePicture({
    required int userId,
    String? filePath,
    Uint8List? bytes,
    String? filename,
  }) async {
    if (bytes == null) {
      final path = filePath?.trim();
      if (path == null || path.isEmpty) {
        throw ArgumentError('filePath is required when bytes is null');
      }
      final response = await remoteDatasource.uploadProfilePictureByUserId(
        userId: userId,
        filePath: path,
      );
      if (!response.success || response.data == null) {
        throw Exception(response.error?.message ?? 'Failed to upload picture');
      }
      // data is "images/profile/<uuid>.<ext>"
      return response.data as String;
    }

    final name = (filename == null || filename.trim().isEmpty)
        ? 'profile.png'
        : filename.trim();

    final response = await remoteDatasource.uploadProfilePictureByUserIdBytes(
      userId: userId,
      bytes: bytes,
      filename: name,
    );
    if (!response.success || response.data == null) {
      throw Exception(response.error?.message ?? 'Failed to upload picture');
    }
    // data is "images/profile/<uuid>.<ext>"
    return response.data as String;
  }

  @override
  Future<void> deleteProfilePicture({required int userId}) async {
    final response = await remoteDatasource.deleteProfilePictureByUserId(
      userId: userId,
    );
    if (!response.success) {
      throw Exception(response.error?.message ?? 'Failed to delete picture');
    }
  }
}
