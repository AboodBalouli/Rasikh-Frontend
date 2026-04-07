import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/seller_page/data/models/create_store_model.dart';
import 'package:flutter_application_1/app/dependency_injection/seller_dependency_injection.dart';

final createStoreProvider = AsyncNotifierProvider<CreateStoreNotifier, void>(
  () {
    return CreateStoreNotifier();
  },
);

class CreateStoreNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> submitStore(StoreModel store) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      // Get necessary dependencies
      final useCase = ref.read(requestSellerRoleUseCaseProvider);

      // Map StoreModel to generic fields or use a mapping logic
      // Note: StoreModel has 'category' as String, but API needs 'categoryId' (int).
      // TODO: Implement proper Category ID lookup.
      // For now, I will use a dummy map based on arabic names found in CreateStorePage
      int categoryId = 0;

      // Map 'category' String to ID.
      // Example: 'أكل' -> 2, 'حرف' -> 23.
      if (store.category == 'أكل') {
        categoryId = 1;
      } else if (store.category == 'حرف') {
        categoryId = 2; // Example IDs.
      } else {
        // Fallback
        categoryId = 2;
      }

      await useCase(
        categoryId: categoryId,
        proofs: store.workSamples,
        note: store.description, // Mapping description to note
        certificate: store.healthLicense,
      );
    });
  }
}
