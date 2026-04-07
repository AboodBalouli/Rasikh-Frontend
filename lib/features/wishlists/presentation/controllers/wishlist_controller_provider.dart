import 'package:flutter_application_1/features/wishlists/presentation/controllers/wishlist_controller.dart';
import 'package:flutter_application_1/features/wishlists/presentation/providers/wishlist_providers.dart';
import 'package:flutter_riverpod/legacy.dart';

final wishlistControllerProvider =
    StateNotifierProvider.autoDispose<WishlistController, WishlistState>((ref) {
      final fetch = ref.watch(fetchMyWishlistUseCaseProvider);
      final add = ref.watch(addToWishlistUseCaseProvider);
      final remove = ref.watch(removeFromWishlistUseCaseProvider);
      return WishlistController(fetch, add, remove)..load();
    });
