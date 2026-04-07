import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/entities/product.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/utils/constants/app_fonts.dart';
import 'package:flutter_application_1/features/wishlists/presentation/controllers/wishlist_controller_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/appBars/nav_bar.dart';
import '../widgets/wishlist_app_bar.dart';
import '../widgets/wishlist_item_card.dart';

@immutable
class WishlistRouteArgs {
  final List<Product> wishlist;
  final Function(Product) onRemove;
  final Function(Product) onAddToCart;
  final Function(Product) onRemoveFromCart;
  final Function(Product) onDeleteFromCart;
  final Map<Product, int> cartItems;
  final Function(Product) onToggleWishlist;
  final Function(Product, int) onUpdateQuantity;

  const WishlistRouteArgs({
    required this.wishlist,
    required this.onRemove,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onDeleteFromCart,
    required this.cartItems,
    required this.onToggleWishlist,
    required this.onUpdateQuantity,
  });
}

class WishlistPage extends ConsumerStatefulWidget {
  final List<Product> wishlist;
  final Function(Product) onRemove;
  final Function(Product) onAddToCart;
  final Function(Product) onRemoveFromCart;
  final Map<Product, int> cartItems;
  final Function(Product) onToggleWishlist;
  final VoidCallback onOpenCart;
  final Function(Product, int) onUpdateQuantity;

  const WishlistPage({
    required this.wishlist,
    required this.onRemove,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.cartItems,
    required this.onToggleWishlist,
    required this.onOpenCart,
    required this.onUpdateQuantity,
    super.key,
  });

  @override
  ConsumerState<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends ConsumerState<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    final wishlistState = ref.watch(wishlistControllerProvider);

    Widget content;

    if (wishlistState.isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (wishlistState.error != null) {
      content = LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Text(
                  wishlistState.error!,
                  style: const TextStyle(
                    fontFamily: AppFonts.parastoo,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      );
    } else if (wishlistState.items.isEmpty) {
      content = LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Text(
                  AppStrings.emptyWishlist,
                  style: const TextStyle(
                    fontFamily: AppFonts.parastoo,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      content = ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: wishlistState.items.length,
        itemBuilder: (context, index) {
          final product = wishlistState.items[index];
          return WishlistItemCard(
            product: product,
            onRemove: () async {
              widget.onRemove(product);
              await ref
                  .read(wishlistControllerProvider.notifier)
                  .toggle(product);
            },
            onAddToCart: widget.onAddToCart,
            onRemoveFromCart: widget.onRemoveFromCart,
            cartItems: widget.cartItems,
            onToggleWishlist: (p) async {
              widget.onToggleWishlist(p);
              await ref.read(wishlistControllerProvider.notifier).toggle(p);
            },
            onOpenCart: widget.onOpenCart,
            onUpdateQuantity: widget.onUpdateQuantity,
          );
        },
      );
    }

    return Scaffold(
      appBar: const WishlistAppBar(),
      body: RefreshIndicator(
        color: const Color.fromARGB(255, 83, 148, 93), // Match brand color
        onRefresh: () async {
          await ref.read(wishlistControllerProvider.notifier).refresh();
        },
        child: content,
      ),
      bottomNavigationBar: const NavBar(currentIndex: 1),
    );
  }
}
