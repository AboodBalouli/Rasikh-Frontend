import '../entities/settings_item.dart';
import '../entities/store_profile_update.dart';

/// Domain-level repository for app settings and store profile.
abstract class SettingsRepository {
  Future<List<SettingsItem>> getSellerSettings();

  /// Update store profile; returns true on success.
  Future<bool> updateStoreProfile(StoreProfileUpdate data);
}
