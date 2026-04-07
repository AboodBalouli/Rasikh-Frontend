import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/core/utils/helpers/snackbar_helper.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart_exception.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_application_1/features/cart/domain/repositories/cart_repository.dart';
import 'package:flutter_application_1/features/shop_page/domain/entities/special_order.dart';
import 'package:flutter_application_1/features/shop_page/domain/repositories/product_repository.dart';
import 'package:flutter_application_1/features/wishlists/domain/repositories/wishlist_repository.dart';

class ShopController extends ChangeNotifier {
  // ══════════════════════════════════════════════════════════════════════════
  // CART QUANTITY DEBOUNCE CONFIGURATION
  // ══════════════════════════════════════════════════════════════════════════
  /// Duration to wait after the last quantity change before sending HTTP request.
  /// Adjust this value as needed.
  static const Duration cartUpdateDebounceDuration = Duration(seconds: 1);
  final ProductRepository repository;
  final CartRepository cartRepository;
  final WishlistRepository wishlistRepository;

  ShopController(this.repository, this.cartRepository, this.wishlistRepository);

  // Products
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Special Orders
  final List<SpecialOrder> _specialOrders = [];

  // Dummy products (fallback)
  final List<Product> _dummyProducts = List.generate(
    10,
    (index) => Product(
      id: 'p$index',
      name: 'Item $index',
      description: 'وصف للمنتج $index',
      price: 20.0 + index,
      imageUrl: 'assets/images/cat1.jpg',
      rating: 4.5,
      reviewCount: 120,
      sellerId: 'seller1',
      category: 'General',
    ),
  );

  // Cart & Wishlist
  final Map<Product, int> _cartItems = {};
  final List<Product> _wishlist = [];

  bool _isRefreshingWishlist = false;
  bool _hasLoadedWishlistOnce = false;

  final Map<String, CartItem> _serverCartItemByProductId = {};
  bool _isRefreshingCart = false;
  bool _hasLoadedCartOnce = false;
  double? _serverTotalAmount;

  // ══════════════════════════════════════════════════════════════════════════
  // CART QUANTITY DEBOUNCE STATE
  // ══════════════════════════════════════════════════════════════════════════
  /// Pending quantity updates: productId → desired quantity
  final Map<String, int> _pendingQuantityUpdates = {};

  /// Original quantities before optimistic update (for rollback on error)
  final Map<String, int> _originalQuantities = {};

  /// Set of product IDs currently being updated (for loading indicator)
  final Set<String> _updatingProductIds = {};

  /// Global debounce timer for cart quantity updates
  Timer? _cartUpdateDebounceTimer;

  // Getters
  List<Product> get products =>
      _products.isNotEmpty ? _products : _dummyProducts;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Map<Product, int> get cartItems => _cartItems;
  List<Product> get wishlist => _wishlist;
  List<SpecialOrder> get specialOrders => _specialOrders;

  int get cartCount =>
      _cartItems.values.fold(0, (sum, quantity) => sum + quantity);

  double get totalPrice => _cartItems.entries.fold(
    0.0,
    (sum, entry) => sum + (entry.key.price * entry.value),
  );

  double get serverTotalPrice => _serverTotalAmount ?? totalPrice;

  /// Returns the set of product IDs that have pending updates being synced.
  /// Use this to show a loading indicator on cart items.
  Set<String> get updatingProductIds => Set.unmodifiable(_updatingProductIds);

  /// Check if a specific product has a pending update.
  bool isProductUpdating(String productId) =>
      _updatingProductIds.contains(productId);

  // API (Clean)
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await repository.getAllProducts();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Wishlist (server-backed)
  Future<void> refreshWishlist({bool force = false}) async {
    if (_isRefreshingWishlist) return;
    if (_hasLoadedWishlistOnce && !force) return;

    _isRefreshingWishlist = true;
    _errorMessage = null;
    try {
      final items = await wishlistRepository.fetchMyWishlist();
      _hasLoadedWishlistOnce = true;

      _wishlist
        ..clear()
        ..addAll(_dedupeById(items));
    } catch (e) {
      // If not authenticated, keep local wishlist behavior.
      _errorMessage = e.toString();
    } finally {
      _isRefreshingWishlist = false;
      notifyListeners();
    }
  }

  List<Product> _dedupeById(List<Product> items) {
    final seen = <String>{};
    final result = <Product>[];
    for (final p in items) {
      if (seen.add(p.id)) result.add(p);
    }
    return result;
  }

  // Cart actions
  Future<void> refreshCart({bool force = false}) async {
    if (_isRefreshingCart) return;
    if (_hasLoadedCartOnce && !force) return;

    _isRefreshingCart = true;
    try {
      final cart = await cartRepository.getMyCart();
      _hasLoadedCartOnce = true;
      _serverTotalAmount = cart.totalAmount;

      _serverCartItemByProductId
        ..clear()
        ..addEntries(
          cart.items.map((e) => MapEntry(e.productId.toString(), e)),
        );

      _cartItems
        ..clear()
        ..addAll(_buildCartItemsMap(cart.items));
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isRefreshingCart = false;
      notifyListeners();
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DEBOUNCED CART QUANTITY UPDATE METHODS
  // ══════════════════════════════════════════════════════════════════════════

  /// Gets the current quantity for a product by ID.
  /// Checks pending updates first, then falls back to cart items.
  int _getQuantityByProductId(String productId) {
    // If there's a pending update, use that value (it's the most recent)
    if (_pendingQuantityUpdates.containsKey(productId)) {
      return _pendingQuantityUpdates[productId]!;
    }

    // Otherwise, find in cart items by ID
    for (final entry in _cartItems.entries) {
      if (entry.key.id == productId) {
        return entry.value;
      }
    }
    return 0;
  }

  /// Finds a Product in _cartItems by its ID.
  Product? _findProductById(String productId) {
    for (final product in _cartItems.keys) {
      if (product.id == productId) {
        return product;
      }
    }
    return null;
  }

  /// Adds one unit of [product] to the cart with debouncing.
  /// The UI updates immediately (optimistic), HTTP request is batched.
  Future<void> addToCart(Product product) async {
    final productId = int.tryParse(product.id);
    if (productId == null) {
      // Non-numeric ID fallback (local only)
      _cartItems[product] = (_cartItems[product] ?? 0) + 1;
      notifyListeners();
      return;
    }

    final currentQty = _getQuantityByProductId(product.id);
    final newQty = currentQty + 1;

    _applyOptimisticQuantityUpdate(product, currentQty, newQty);
  }

  /// Removes one unit of [product] from the cart with debouncing.
  /// The UI updates immediately (optimistic), HTTP request is batched.
  Future<void> removeFromCart(Product product) async {
    final productId = int.tryParse(product.id);
    if (productId == null) {
      // Non-numeric ID fallback (local only)
      if (_cartItems.containsKey(product)) {
        if (_cartItems[product]! > 1) {
          _cartItems[product] = _cartItems[product]! - 1;
        } else {
          _cartItems.remove(product);
        }
        notifyListeners();
      }
      return;
    }

    final currentQty = _getQuantityByProductId(product.id);
    if (currentQty <= 0) return;

    final newQty = currentQty - 1;
    _applyOptimisticQuantityUpdate(product, currentQty, newQty);
  }

  /// Core method: applies optimistic update and schedules debounced sync.
  void _applyOptimisticQuantityUpdate(
    Product product,
    int originalQty,
    int newQty,
  ) {
    final productId = product.id;

    // Store original quantity for potential rollback (only if not already stored)
    // Use the SERVER quantity as original, not the pending/optimistic one
    if (!_originalQuantities.containsKey(productId)) {
      // Get the server-side quantity (before any optimistic updates)
      final serverCartItem = _serverCartItemByProductId[productId];
      _originalQuantities[productId] = serverCartItem?.quantity ?? 0;
    }

    // Find existing product in cart or use the passed one
    final existingProduct = _findProductById(productId);
    final productToUse = existingProduct ?? product;

    // Apply optimistic update to UI immediately
    if (newQty <= 0) {
      _cartItems.remove(productToUse);
    } else {
      _cartItems[productToUse] = newQty;
    }

    // Track pending update
    _pendingQuantityUpdates[productId] = newQty;

    // Mark as updating (for loading indicator)
    _updatingProductIds.add(productId);

    notifyListeners();

    // Reset and start the global debounce timer
    _scheduleCartSync();
  }

  /// Schedules (or re-schedules) the global cart sync after debounce duration.
  void _scheduleCartSync() {
    _cartUpdateDebounceTimer?.cancel();
    _cartUpdateDebounceTimer = Timer(
      cartUpdateDebounceDuration,
      _flushPendingCartUpdates,
    );
  }

  /// Flushes all pending quantity updates to the backend.
  /// This is called when the debounce timer fires or when navigating away.
  Future<void> _flushPendingCartUpdates() async {
    if (_pendingQuantityUpdates.isEmpty) return;

    // Copy and clear pending updates to allow new updates during sync
    final updates = Map<String, int>.from(_pendingQuantityUpdates);
    final originals = Map<String, int>.from(_originalQuantities);
    _pendingQuantityUpdates.clear();
    _originalQuantities.clear();

    // Process each pending update
    final failedUpdates = <String, int>{};

    for (final entry in updates.entries) {
      final productId = entry.key;
      final newQty = entry.value;

      try {
        final cartItem = _serverCartItemByProductId[productId];

        if (cartItem == null) {
          // Product not in server cart yet - need to add it
          final numericId = int.tryParse(productId);
          if (numericId != null && newQty > 0) {
            await cartRepository.addItemToCart(
              productId: numericId,
              quantity: newQty,
            );
          }
        } else if (newQty <= 0) {
          // Remove from cart
          await cartRepository.removeItemFromCart(cartItemId: cartItem.id);
        } else {
          // Update quantity
          await cartRepository.updateCartItemQuantity(
            cartItemId: cartItem.id,
            quantity: newQty,
          );
        }
      } on CartException catch (e) {
        failedUpdates[productId] = originals[productId] ?? 0;
        SnackbarHelper.showSnackBar(e.message, isError: true);
      } catch (e) {
        failedUpdates[productId] = originals[productId] ?? 0;
        SnackbarHelper.showSnackBar(
          'Failed to update cart. Please try again.',
          isError: true,
        );
      } finally {
        _updatingProductIds.remove(productId);
      }
    }

    // Rollback failed updates
    if (failedUpdates.isNotEmpty) {
      for (final entry in failedUpdates.entries) {
        final productId = entry.key;
        final originalQty = entry.value;

        // Find the product in cart items
        final product = _cartItems.keys.cast<Product?>().firstWhere(
          (p) => p?.id == productId,
          orElse: () => null,
        );

        if (product != null) {
          if (originalQty <= 0) {
            _cartItems.remove(product);
          } else {
            _cartItems[product] = originalQty;
          }
        }
      }
    }

    // Update local server cart item cache with new quantities (no backend fetch)
    for (final entry in updates.entries) {
      final productId = entry.key;
      final newQty = entry.value;
      if (!failedUpdates.containsKey(productId)) {
        final cartItem = _serverCartItemByProductId[productId];
        if (cartItem != null && newQty > 0) {
          // Update the cached server cart item quantity
          _serverCartItemByProductId[productId] = CartItem(
            id: cartItem.id,
            productId: cartItem.productId,
            productName: cartItem.productName,
            productDescription: cartItem.productDescription,
            productPrice: cartItem.productPrice,
            quantity: newQty,
            subtotal: cartItem.productPrice * newQty,
            productImagePath: cartItem.productImagePath,
            sellerProfileId: cartItem.sellerProfileId,
            sellerFirstName: cartItem.sellerFirstName,
            sellerLastName: cartItem.sellerLastName,
          );
        } else if (newQty <= 0) {
          _serverCartItemByProductId.remove(productId);
        }
      }
    }

    notifyListeners();
  }

  /// Call this when navigating away from cart to ensure pending updates are sent.
  /// This is fire-and-forget - the navigation can proceed immediately.
  void flushCartUpdatesOnNavigate() {
    _cartUpdateDebounceTimer?.cancel();
    _cartUpdateDebounceTimer = null;
    _flushPendingCartUpdates();
  }

  /// Deletes [product] entirely from the cart (immediate, no debounce).
  /// Use this for swipe-to-delete or explicit "remove item" actions.
  Future<void> deleteFromCart(Product product) async {
    // Cancel any pending updates for this product
    _pendingQuantityUpdates.remove(product.id);
    _originalQuantities.remove(product.id);
    _updatingProductIds.remove(product.id);

    final cartItem = _serverCartItemByProductId[product.id];

    // Find the product in cart by ID and remove it
    final existingProduct = _findProductById(product.id);
    if (existingProduct != null) {
      _cartItems.remove(existingProduct);
    } else {
      _cartItems.remove(product);
    }
    notifyListeners();

    if (cartItem == null) {
      return;
    }

    try {
      await cartRepository.removeItemFromCart(cartItemId: cartItem.id);
      // Remove from local cache
      _serverCartItemByProductId.remove(product.id);
    } on CartException catch (e) {
      SnackbarHelper.showSnackBar(e.message, isError: true);
      // Rollback - re-add to cart
      final existingProduct = _findProductById(product.id);
      if (existingProduct != null && cartItem.quantity > 0) {
        _cartItems[existingProduct] = cartItem.quantity;
      } else {
        _cartItems[product] = cartItem.quantity;
      }
      notifyListeners();
    } catch (e) {
      SnackbarHelper.showSnackBar(
        'Failed to remove item. Please try again.',
        isError: true,
      );
      // Rollback - re-add to cart
      final existingProduct = _findProductById(product.id);
      if (existingProduct != null && cartItem.quantity > 0) {
        _cartItems[existingProduct] = cartItem.quantity;
      } else {
        _cartItems[product] = cartItem.quantity;
      }
      notifyListeners();
    }
  }

  /// Updates [product] quantity directly (uses debouncing).
  Future<void> updateCartQuantity(Product product, int quantity) async {
    final productId = int.tryParse(product.id);

    // Fallback: non-numeric IDs can't be synced with the current cart API.
    if (productId == null) {
      if (quantity <= 0) {
        _cartItems.remove(product);
      } else {
        _cartItems[product] = quantity;
      }
      notifyListeners();
      return;
    }

    final currentQty = _getQuantityByProductId(product.id);
    _applyOptimisticQuantityUpdate(product, currentQty, quantity);
  }

  Map<Product, int> _buildCartItemsMap(List<CartItem> items) {
    final Map<Product, int> result = {};
    final candidates = _products.isNotEmpty ? _products : _dummyProducts;

    for (final item in items) {
      final productId = item.productId.toString();
      final product = candidates.cast<Product?>().firstWhere(
        (p) => p?.id == productId,
        orElse: () => null,
      );

      if (product != null) {
        result[product] = item.quantity;
      } else {
        result[Product(
              id: productId,
              name: item.productName,
              description: item.productDescription,
              price: item.productPrice,
              imageUrl: 'assets/images/cat1.jpg',
              rating: 0.0,
              reviewCount: 0,
              sellerId: item.sellerProfileId.toString(),
              category: 'General',
            )] =
            item.quantity;
      }
    }

    return result;
  }

  // Wishlist actions
  void toggleWishlist(Product product) {
    final already = _wishlist.any((p) => p.id == product.id);

    // Optimistic update
    if (already) {
      _wishlist.removeWhere((p) => p.id == product.id);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();

    // Fire-and-forget sync (keeps existing VoidCallback API)
    _syncWishlistToggle(product, already: already);
  }

  Future<void> _syncWishlistToggle(
    Product product, {
    required bool already,
  }) async {
    try {
      if (already) {
        await wishlistRepository.removeFromWishlist(product.id);
      } else {
        final added = await wishlistRepository.addToWishlist(product.id);
        // Replace optimistic item with backend-mapped one (image URL, etc.)
        _wishlist
          ..removeWhere((p) => p.id == product.id)
          ..add(added);
      }
    } catch (e) {
      // Revert optimistic update on failure
      if (already) {
        _wishlist.add(product);
      } else {
        _wishlist.removeWhere((p) => p.id == product.id);
      }
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void removeFromWishlist(Product product) {
    final existed = _wishlist.any((p) => p.id == product.id);
    _wishlist.removeWhere((p) => p.id == product.id);
    notifyListeners();

    if (!existed) return;
    _syncRemoveFromWishlist(product);
  }

  Future<void> _syncRemoveFromWishlist(Product product) async {
    try {
      await wishlistRepository.removeFromWishlist(product.id);
    } catch (e) {
      // Best-effort: re-add locally if server remove failed
      _wishlist.add(product);
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Special Orders actions
  void addSpecialOrder(SpecialOrder order) {
    _specialOrders.add(order);
    notifyListeners();
  }

  void updateSpecialOrder(SpecialOrder updatedOrder) {
    final index = _specialOrders.indexWhere((o) => o.id == updatedOrder.id);
    if (index != -1) {
      _specialOrders[index] = updatedOrder;
      notifyListeners();
    }
  }

  /// Clears all user-specific data (cart, wishlist, special orders).
  /// Call this when the user logs out.
  void clearData() {
    _cartItems.clear();
    _wishlist.clear();
    _specialOrders.clear();
    _serverCartItemByProductId.clear();
    _pendingQuantityUpdates.clear();
    _originalQuantities.clear();
    _updatingProductIds.clear();
    _hasLoadedWishlistOnce = false;
    _hasLoadedCartOnce = false;
    _serverTotalAmount = null;

    notifyListeners();
  }
}
