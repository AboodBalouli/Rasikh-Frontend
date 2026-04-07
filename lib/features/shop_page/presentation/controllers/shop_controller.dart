import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_application_1/features/cart/domain/repositories/cart_repository.dart';
import 'package:flutter_application_1/features/wishlists/domain/repositories/wishlist_repository.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import '../../domain/entities/special_order.dart';
import '../../domain/repositories/product_repository.dart';

class ShopController extends ChangeNotifier {
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
      imageUrl: "assets/images/cat1.jpg",
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

  Future<void> addToCart(Product product) async {
    final productId = int.tryParse(product.id);
    if (productId == null) {
      _cartItems[product] = (_cartItems[product] ?? 0) + 1;
      notifyListeners();
      return;
    }

    await cartRepository.addItemToCart(productId: productId, quantity: 1);
    await refreshCart(force: true);
  }

  Future<void> removeFromCart(Product product) async {
    final productId = product.id;
    final cartItem = _serverCartItemByProductId[productId];

    if (cartItem == null) {
      if (_cartItems.containsKey(product)) {
        if (_cartItems[product]! > 1) {
          _cartItems[product] = _cartItems[product]! - 1;
        } else {
          _cartItems.remove(product);
        }
        notifyListeners();
      }
      await refreshCart(force: true);
      return;
    }

    if (cartItem.quantity > 1) {
      await cartRepository.updateCartItemQuantity(
        cartItemId: cartItem.id,
        quantity: cartItem.quantity - 1,
      );
    } else {
      await cartRepository.removeItemFromCart(cartItemId: cartItem.id);
    }

    await refreshCart(force: true);
  }

  Future<void> deleteFromCart(Product product) async {
    final cartItem = _serverCartItemByProductId[product.id];
    if (cartItem == null) {
      _cartItems.remove(product);
      notifyListeners();
      await refreshCart(force: true);
      return;
    }

    await cartRepository.removeItemFromCart(cartItemId: cartItem.id);
    await refreshCart(force: true);
  }

  Future<void> updateCartQuantity(Product product, int quantity) async {
    final cartItem = _serverCartItemByProductId[product.id];
    if (cartItem == null) {
      // If we don't have a server cart item yet, we must create it first.
      // Otherwise a refresh will overwrite any local optimistic quantity.
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

      if (quantity <= 0) {
        // Nothing to remove server-side if it doesn't exist.
        _cartItems.remove(product);
        notifyListeners();
        return;
      }

      // Create the cart item on the backend, then refresh local state.
      try {
        await cartRepository.addItemToCart(
          productId: productId,
          quantity: quantity,
        );
        await refreshCart(force: true);
      } catch (e) {
        // Best-effort: keep the local optimistic value if the server call fails.
        _errorMessage = e.toString();
        _cartItems[product] = quantity;
        notifyListeners();
      }
      return;
    }

    if (quantity <= 0) {
      await cartRepository.removeItemFromCart(cartItemId: cartItem.id);
    } else {
      await cartRepository.updateCartItemQuantity(
        cartItemId: cartItem.id,
        quantity: quantity,
      );
    }

    await refreshCart(force: true);
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
}
