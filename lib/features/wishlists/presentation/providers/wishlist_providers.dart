import 'package:flutter_application_1/app/dependency_injection/wishlist_dependency_injection.dart';
import 'package:flutter_application_1/features/wishlists/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:flutter_application_1/features/wishlists/domain/usecases/fetch_my_wishlist_usecase.dart';
import 'package:flutter_application_1/features/wishlists/domain/usecases/remove_from_wishlist_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchMyWishlistUseCaseProvider = Provider<FetchMyWishlistUseCase>((ref) {
  final repo = ref.watch(wishlistRepositoryProvider);
  return FetchMyWishlistUseCase(repo);
});

final addToWishlistUseCaseProvider = Provider<AddToWishlistUseCase>((ref) {
  final repo = ref.watch(wishlistRepositoryProvider);
  return AddToWishlistUseCase(repo);
});

final removeFromWishlistUseCaseProvider = Provider<RemoveFromWishlistUseCase>((
  ref,
) {
  final repo = ref.watch(wishlistRepositoryProvider);
  return RemoveFromWishlistUseCase(repo);
});
