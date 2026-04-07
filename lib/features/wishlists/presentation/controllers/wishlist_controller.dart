import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/features/wishlists/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:flutter_application_1/features/wishlists/domain/usecases/fetch_my_wishlist_usecase.dart';
import 'package:flutter_application_1/features/wishlists/domain/usecases/remove_from_wishlist_usecase.dart';
import 'package:flutter_riverpod/legacy.dart';

class WishlistState {
  final bool isLoading;
  final List<Product> items;
  final String? error;

  const WishlistState({
    required this.isLoading,
    required this.items,
    required this.error,
  });

  const WishlistState.initial()
    : isLoading = false,
      items = const [],
      error = null;

  WishlistState copyWith({
    bool? isLoading,
    List<Product>? items,
    String? error,
  }) {
    return WishlistState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      error: error,
    );
  }
}

class WishlistController extends StateNotifier<WishlistState> {
  final FetchMyWishlistUseCase _fetch;
  final AddToWishlistUseCase _add;
  final RemoveFromWishlistUseCase _remove;

  WishlistController(this._fetch, this._add, this._remove)
    : super(const WishlistState.initial());

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final items = await _fetch();
      state = state.copyWith(isLoading: false, items: items);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    try {
      final items = await _fetch();
      state = state.copyWith(items: items, error: null);
    } catch (e) {
      // Keep existing items but update error state if needed,
      // or handling it via UI (e.g. snackbar) would be better,
      // but for now we basically ignore error or set it.
      // Setting error might replace the list with error view in current UI logic.
      // Let's just log or set error if valid.
      state = state.copyWith(error: e.toString());
    }
  }

  bool contains(Product product) {
    return state.items.any((p) => p.id == product.id);
  }

  Future<void> toggle(Product product) async {
    final already = contains(product);

    // optimistic UI
    if (already) {
      state = state.copyWith(
        items: state.items.where((p) => p.id != product.id).toList(),
      );
    } else {
      state = state.copyWith(items: [...state.items, product]);
    }

    try {
      if (already) {
        await _remove(product.id);
      } else {
        final added = await _add(product.id);
        state = state.copyWith(
          items: [
            for (final p in state.items)
              if (p.id == product.id) added else p,
          ],
        );
      }
    } catch (e) {
      // revert on failure
      if (already) {
        state = state.copyWith(items: [...state.items, product]);
      } else {
        state = state.copyWith(
          items: state.items.where((p) => p.id != product.id).toList(),
        );
      }
      state = state.copyWith(error: e.toString());
    }
  }
}
