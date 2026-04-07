import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/helpers/snackbar_helper.dart';
import 'package:flutter_application_1/features/cart/presentation/providers/cart_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/cart_app_bar.dart';
import '../widgets/cart_bottom_bar.dart';
import '../widgets/cart_item_card.dart';
import 'empty_cart_page.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(cartControllerProvider, (prev, next) {
      final message = next.errorMessage;
      final prevMessage = prev?.errorMessage;
      if (message != null &&
          message.trim().isNotEmpty &&
          message != prevMessage) {
        SnackbarHelper.showSnackBar(message, isError: true);
      }
    });

    final state = ref.watch(cartControllerProvider);
    final controller = ref.read(cartControllerProvider.notifier);

    final cart = state.cart;
    final items = cart?.items ?? const [];
    final totalPrice = (cart?.totalAmount ?? 0).toDouble();

    if (state.isLoading && cart == null) {
      return const Scaffold(
        appBar: CartAppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (items.isEmpty) {
      return const EmptyCartPage();
    }

    return Scaffold(
      appBar: const CartAppBar(),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.loadCart(showLoading: false),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return CartItemCard(
                    item: item,
                    isUpdating: state.updatingCartItemIds.contains(item.id),
                    onAdd: () => controller.increment(item),
                    onRemove: () => controller.decrement(item),
                    onDelete: () => controller.remove(item),
                  );
                },
              ),
            ),
          ),
          CartBottomBar(
            noteController: _noteController,
            totalPrice: totalPrice,
            isCartEmpty: items.isEmpty,
            hasPendingUpdates: state.hasPendingUpdates,
            onCheckout: () {
              context.push('/checkout', extra: totalPrice);
            },
          ),
        ],
      ),
    );
  }
}
