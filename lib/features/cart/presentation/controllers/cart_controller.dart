import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import 'package:flutter_application_1/features/cart/domain/entities/cart.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart_exception.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_application_1/features/cart/domain/usecases/add_item_to_cart_usecase.dart';
import 'package:flutter_application_1/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:flutter_application_1/features/cart/domain/usecases/get_my_cart_usecase.dart';
import 'package:flutter_application_1/features/cart/domain/usecases/remove_item_from_cart_usecase.dart';
import 'package:flutter_application_1/features/cart/domain/usecases/update_cart_item_quantity_usecase.dart';

import 'cart_state.dart';

class CartController extends StateNotifier<CartState> {
  static const Duration _quantityDebounce = Duration(milliseconds: 500);

  final GetMyCartUsecase _getMyCart;
  final AddItemToCartUsecase _addItem;
  final UpdateCartItemQuantityUsecase _updateQuantity;
  final RemoveItemFromCartUsecase _removeItem;
  final ClearCartUsecase _clearCart;

  final Map<int, Timer> _debounceTimersByProductId = {};
  final Map<int, int> _desiredQuantityByProductId = {};
  final Map<int, DateTime> _lastChangeAtByProductId = {};
  final Set<int> _inFlightProductIds = <int>{};

  CartController(
    this._getMyCart,
    this._addItem,
    this._updateQuantity,
    this._removeItem,
    this._clearCart,
  ) : super(CartState.initial());

  @override
  void dispose() {
    for (final timer in _debounceTimersByProductId.values) {
      timer.cancel();
    }
    _debounceTimersByProductId.clear();
    super.dispose();
  }

  Future<void> loadCart({
    bool showLoading = true,
    bool preserveOptimistic = false,
  }) async {
    try {
      if (showLoading) {
        state = state.copyWith(isLoading: true, errorMessage: null);
      } else {
        state = state.copyWith(errorMessage: null);
      }

      final cart = await _getMyCart();

      final optimistic = preserveOptimistic
          ? state.optimisticQuantityByProductId
          : const <int, int>{};
      final pending = preserveOptimistic
          ? state.pendingProductIds
          : const <int>{};
      final updating = preserveOptimistic
          ? state.updatingCartItemIds
          : const <int>{};

      state = state.copyWith(
        confirmedCart: cart,
        cart: _applyOptimisticToCart(
          base: cart,
          optimisticQuantityByProductId: optimistic,
        ),
        optimisticQuantityByProductId: optimistic,
        pendingProductIds: pending,
        updatingCartItemIds: updating,
      );
    } on CartException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    } catch (_) {
      state = state.copyWith(errorMessage: 'Failed to load cart');
    } finally {
      if (showLoading) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<void> increment(CartItem item) async {
    await setProductQuantity(
      productId: item.productId,
      quantity: item.quantity + 1,
    );
  }

  Future<void> decrement(CartItem item) async {
    await setProductQuantity(
      productId: item.productId,
      quantity: item.quantity - 1,
    );
  }

  Future<void> remove(CartItem item) async {
    final updating = {...state.updatingCartItemIds}..add(item.id);
    state = state.copyWith(updatingCartItemIds: updating, errorMessage: null);

    try {
      await _removeItem(cartItemId: item.id);
      await loadCart(showLoading: false, preserveOptimistic: false);
    } on CartException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    } catch (_) {
      state = state.copyWith(errorMessage: 'Failed to remove item');
    } finally {
      final next = {...state.updatingCartItemIds}..remove(item.id);
      state = state.copyWith(updatingCartItemIds: next);
    }
  }

  Future<void> clear() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      await _clearCart();
      await loadCart(showLoading: false, preserveOptimistic: false);
    } on CartException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    } catch (_) {
      state = state.copyWith(errorMessage: 'Failed to clear cart');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addProduct({required int productId, int quantity = 1}) async {
    try {
      state = state.copyWith(errorMessage: null);
      await _addItem(productId: productId, quantity: quantity);
      await loadCart(showLoading: false, preserveOptimistic: false);
    } on CartException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    } catch (_) {
      state = state.copyWith(errorMessage: 'Failed to add item');
    }
  }

  /// Optimistic immediate update + debounced backend commit.
  ///
  /// - UI updates instantly (badge + product quantity + cart page quantity)
  /// - Backend call is debounced per-product by 500ms
  /// - On success: silently refresh via loadCart(showLoading:false)
  /// - On failure: revert to last confirmed cart quantity
  Future<void> setProductQuantity({
    required int productId,
    required int quantity,
  }) async {
    final clamped = quantity < 0 ? 0 : quantity;
    _applyOptimisticQuantity(productId: productId, quantity: clamped);
    _scheduleDebouncedCommit(productId: productId);
  }

  Future<void> setProductQuantityByStringId({
    required String productId,
    required int quantity,
  }) async {
    final parsed = int.tryParse(productId);
    if (parsed == null) {
      state = state.copyWith(errorMessage: 'Invalid product id');
      return;
    }
    await setProductQuantity(productId: parsed, quantity: quantity);
  }

  void _applyOptimisticQuantity({
    required int productId,
    required int quantity,
  }) {
    final nextOptimistic = Map<int, int>.from(
      state.optimisticQuantityByProductId,
    );
    nextOptimistic[productId] = quantity;

    final nextPending = {...state.pendingProductIds}..add(productId);
    final nextUpdatingIds = _markUpdatingCartItemIdsForProduct(
      productId: productId,
      add: false,
    );

    state = state.copyWith(
      cart: _applyOptimisticToCart(
        base: state.confirmedCart,
        optimisticQuantityByProductId: nextOptimistic,
      ),
      optimisticQuantityByProductId: nextOptimistic,
      pendingProductIds: nextPending,
      updatingCartItemIds: nextUpdatingIds,
      errorMessage: null,
    );

    _desiredQuantityByProductId[productId] = quantity;
    _lastChangeAtByProductId[productId] = DateTime.now();
  }

  void _scheduleDebouncedCommit({required int productId}) {
    _debounceTimersByProductId[productId]?.cancel();
    _debounceTimersByProductId[productId] = Timer(
      _quantityDebounce,
      () => _commitIfReady(productId: productId),
    );
  }

  void _commitIfReady({required int productId}) {
    if (!mounted) return;

    if (_inFlightProductIds.contains(productId)) {
      // There's an API call in-flight for this product. We'll reschedule once it completes.
      return;
    }

    final desired = _desiredQuantityByProductId[productId];
    if (desired == null) return;

    _commitQuantity(productId: productId, desiredQuantity: desired);
  }

  Future<void> _commitQuantity({
    required int productId,
    required int desiredQuantity,
  }) async {
    if (!mounted) return;

    final commitTokenAtStart = _lastChangeAtByProductId[productId];
    final desiredAtStart = desiredQuantity;

    _inFlightProductIds.add(productId);
    _debounceTimersByProductId[productId]?.cancel();

    final confirmedItem = _findItemByProductId(
      productId,
      inCart: state.confirmedCart,
    );

    // If it's an existing cart line, we can show the per-line updating overlay.
    final nextUpdatingIds = _markUpdatingCartItemIdsForProduct(
      productId: productId,
      add: true,
    );
    state = state.copyWith(
      updatingCartItemIds: nextUpdatingIds,
      errorMessage: null,
    );

    // If backend already matches desired quantity, treat as done.
    // This prevents infinite loops where we keep refreshing without changes.
    final confirmedQty = confirmedItem?.quantity ?? 0;
    if (confirmedItem == null && desiredQuantity <= 0) {
      _clearPendingForProduct(productId);
      _inFlightProductIds.remove(productId);
      state = state.copyWith(
        updatingCartItemIds: _markUpdatingCartItemIdsForProduct(
          productId: productId,
          add: false,
        ),
      );
      return;
    }
    if (confirmedItem != null && desiredQuantity == confirmedQty) {
      _clearPendingForProduct(productId);
      _inFlightProductIds.remove(productId);
      state = state.copyWith(
        updatingCartItemIds: _markUpdatingCartItemIdsForProduct(
          productId: productId,
          add: false,
        ),
      );
      return;
    }

    try {
      if (confirmedItem == null) {
        if (desiredQuantity > 0) {
          await _addItem(productId: productId, quantity: desiredQuantity);
        }
      } else {
        if (desiredQuantity <= 0) {
          await _removeItem(cartItemId: confirmedItem.id);
        } else if (desiredQuantity != confirmedItem.quantity) {
          await _updateQuantity(
            cartItemId: confirmedItem.id,
            quantity: desiredQuantity,
          );
        }
      }

      // After successful write, refresh cart in background.
      await loadCart(showLoading: false, preserveOptimistic: true);

      // Clear pending only if the user didn't change again during this request.
      final latestDesired = _desiredQuantityByProductId[productId];
      final latestToken = _lastChangeAtByProductId[productId];
      final changedDuringRequest =
          latestDesired != desiredAtStart || latestToken != commitTokenAtStart;
      if (!changedDuringRequest) {
        _clearPendingForProduct(productId);
      }
    } on CartException catch (e) {
      _revertOptimisticQuantity(productId: productId);
      state = state.copyWith(errorMessage: e.message);
    } catch (_) {
      _revertOptimisticQuantity(productId: productId);
      state = state.copyWith(errorMessage: 'Failed to update quantity');
    } finally {
      _inFlightProductIds.remove(productId);

      // Remove per-line updating overlay if it was added.
      final cleanedUpdating = _markUpdatingCartItemIdsForProduct(
        productId: productId,
        add: false,
      );
      state = state.copyWith(updatingCartItemIds: cleanedUpdating);

      // If user changed again while the request was in-flight, schedule the next commit
      // honoring the debounce window relative to the last change.
      final lastChangedAt = _lastChangeAtByProductId[productId];
      final latestDesired = _desiredQuantityByProductId[productId];
      if (lastChangedAt != null && latestDesired != null) {
        // Only reschedule if something changed since this commit started.
        if (lastChangedAt == commitTokenAtStart &&
            latestDesired == desiredAtStart) {
          return;
        }
        final elapsed = DateTime.now().difference(lastChangedAt);
        if (elapsed >= _quantityDebounce &&
            !_inFlightProductIds.contains(productId)) {
          _commitIfReady(productId: productId);
        } else {
          final remaining = _quantityDebounce - elapsed;
          _debounceTimersByProductId[productId]?.cancel();
          _debounceTimersByProductId[productId] = Timer(
            remaining.isNegative ? Duration.zero : remaining,
            () => _commitIfReady(productId: productId),
          );
        }
      }
    }
  }

  void _clearPendingForProduct(int productId) {
    _desiredQuantityByProductId.remove(productId);
    _lastChangeAtByProductId.remove(productId);
    _debounceTimersByProductId[productId]?.cancel();
    _debounceTimersByProductId.remove(productId);

    final nextOptimistic = Map<int, int>.from(
      state.optimisticQuantityByProductId,
    )..remove(productId);
    final nextPending = {...state.pendingProductIds}..remove(productId);

    state = state.copyWith(
      cart: _applyOptimisticToCart(
        base: state.confirmedCart,
        optimisticQuantityByProductId: nextOptimistic,
      ),
      optimisticQuantityByProductId: nextOptimistic,
      pendingProductIds: nextPending,
    );
  }

  void _revertOptimisticQuantity({required int productId}) {
    final nextOptimistic = Map<int, int>.from(
      state.optimisticQuantityByProductId,
    )..remove(productId);
    final nextPending = {...state.pendingProductIds}..remove(productId);

    _desiredQuantityByProductId.remove(productId);
    _lastChangeAtByProductId.remove(productId);

    state = state.copyWith(
      cart: _applyOptimisticToCart(
        base: state.confirmedCart,
        optimisticQuantityByProductId: nextOptimistic,
      ),
      optimisticQuantityByProductId: nextOptimistic,
      pendingProductIds: nextPending,
    );
  }

  Set<int> _markUpdatingCartItemIdsForProduct({
    required int productId,
    required bool add,
  }) {
    final current = {...state.updatingCartItemIds};
    final confirmedItem = _findItemByProductId(
      productId,
      inCart: state.confirmedCart ?? state.cart,
    );
    if (confirmedItem == null) return current;
    if (add) {
      current.add(confirmedItem.id);
    } else {
      current.remove(confirmedItem.id);
    }
    return current;
  }

  Cart? _applyOptimisticToCart({
    required Cart? base,
    required Map<int, int> optimisticQuantityByProductId,
  }) {
    if (base == null) return null;
    if (optimisticQuantityByProductId.isEmpty) return base;

    // NOTE: Cart is immutable in domain layer in this codebase, so we rebuild the items
    // list with updated quantities/subtotals for products that already exist in the cart.
    // Products not present in base cart will only affect badges/product cards until a refresh.
    final nextItems = <CartItem>[];
    for (final item in base.items) {
      final overrideQty = optimisticQuantityByProductId[item.productId];
      if (overrideQty == null) {
        nextItems.add(item);
        continue;
      }
      if (overrideQty <= 0) {
        // Optimistically remove.
        continue;
      }

      nextItems.add(
        CartItem(
          id: item.id,
          productId: item.productId,
          productName: item.productName,
          productDescription: item.productDescription,
          productPrice: item.productPrice,
          quantity: overrideQty,
          subtotal: item.productPrice * overrideQty,
          productImagePath: item.productImagePath,
          sellerProfileId: item.sellerProfileId,
          sellerFirstName: item.sellerFirstName,
          sellerLastName: item.sellerLastName,
        ),
      );
    }

    final totalItems = nextItems.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );
    final totalAmount = nextItems.fold<double>(
      0,
      (sum, item) => sum + item.subtotal,
    );

    return Cart(
      items: nextItems,
      totalItems: totalItems,
      totalAmount: totalAmount,
    );
  }

  CartItem? _findItemByProductId(int productId, {Cart? inCart}) {
    final items = (inCart ?? state.cart)?.items;
    if (items == null) return null;
    for (final item in items) {
      if (item.productId == productId) return item;
    }
    return null;
  }
}
