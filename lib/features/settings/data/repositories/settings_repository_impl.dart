import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/network/api_service.dart';
import 'package:flutter_application_1/core/network/api_endpoints.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/entities/settings_item.dart';
import '../../domain/entities/store_profile_update.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final ApiService apiService;

  SettingsRepositoryImpl(this.apiService);

  @override
  Future<List<SettingsItem>> getSellerSettings() async {
    // For now return simple in-memory settings; could call API:
    // final raw = await apiService.get(ApiEndpoints.settings);
    const icon = Icons.store;
    return [
      SettingsItem(
        title: 'Store Info',
        description: 'Edit your store details',
        iconCodePoint: icon.codePoint,
        iconFontFamily: icon.fontFamily,
        iconFontPackage: icon.fontPackage,
        iconMatchTextDirection: icon.matchTextDirection,
        colorValue: Colors.blue.toARGB32(),
      ),
    ];
  }

  @override
  Future<bool> updateStoreProfile(StoreProfileUpdate data) async {
    try {
      final payload = {
        'name': data.newName,
        'bio': data.newBio,
        'location': data.newLocation,
      };
      // If the backend accepts multipart for avatar, the ApiService should
      // be extended. For now send JSON.
      await apiService.post(ApiEndpoints.updateStore('me'), payload);
      return true;
    } catch (_) {
      return false;
    }
  }
}
