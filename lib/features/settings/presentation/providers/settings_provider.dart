import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import '/core/network/api_service.dart';
import '/features/settings/data/repositories/settings_repository_impl.dart';
import '/features/settings/domain/repositories/settings_repository.dart';
import '/features/settings/domain/entities/store_profile_update.dart';
import '/features/settings/domain/entities/settings_item.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

enum UserType { seller, charity }

final userTypeProvider = NotifierProvider<UserTypeNotifier, UserType>(() {
  return UserTypeNotifier();
});

class UserTypeNotifier extends Notifier<UserType> {
  @override
  UserType build() => UserType.seller;
  void setType(UserType type) => state = type;
}

final userImageProvider = NotifierProvider<UserImageNotifier, Uint8List?>(() {
  return UserImageNotifier();
});

class UserImageNotifier extends Notifier<Uint8List?> {
  @override
  Uint8List? build() => null;
  void setImage(Uint8List? image) => state = image;
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final api = ref.read(apiServiceProvider);
  return SettingsRepositoryImpl(api);
});

final sellerSettingsProvider = FutureProvider.autoDispose<List<SettingsItem>>((
  ref,
) async {
  final repo = ref.read(settingsRepositoryProvider);
  return repo.getSellerSettings();
});

final updateStoreProvider = Provider<Future<bool> Function(StoreProfileUpdate)>(
  (ref) {
    final repo = ref.read(settingsRepositoryProvider);
    return (StoreProfileUpdate data) => repo.updateStoreProfile(data);
  },
);
