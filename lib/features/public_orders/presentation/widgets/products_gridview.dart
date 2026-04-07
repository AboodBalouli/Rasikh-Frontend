import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/public_orders/domain/entities/public_order.dart';
import 'package:flutter_application_1/features/public_orders/presentation/controllers/orders_feed_controller.dart';
import 'package:flutter_application_1/features/public_orders/presentation/providers/orders_providers.dart';
import 'package:flutter_application_1/features/public_orders/presentation/widgets/public_order_product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class ProductsGridView extends ConsumerStatefulWidget {
  const ProductsGridView({super.key});

  @override
  ConsumerState<ProductsGridView> createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends ConsumerState<ProductsGridView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final query = ref.read(publicOrdersSearchQueryProvider).trim();
    // When searching locally, don't auto-fetch more pages.
    if (query.isNotEmpty) return;

    final mode = ref.read(publicOrdersFeedModeProvider);
    if (mode == PublicOrdersFeedMode.mine) return;

    const threshold = 300.0;
    if (_scrollController.position.extentAfter > threshold) return;

    switch (mode) {
      case PublicOrdersFeedMode.all:
        ref.read(publicOrdersFeedControllerProvider.notifier).loadMore();
        break;
      case PublicOrdersFeedMode.displayed:
        ref
            .read(
              publicOrdersByStatusFeedControllerProvider('DISPLAYED').notifier,
            )
            .loadMore();
        break;
      case PublicOrdersFeedMode.completed:
        ref
            .read(
              publicOrdersByStatusFeedControllerProvider('COMPLETED').notifier,
            )
            .loadMore();
        break;
      case PublicOrdersFeedMode.mine:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(publicOrdersFeedModeProvider);
    final query = ref
        .watch(publicOrdersSearchQueryProvider)
        .trim()
        .toLowerCase();

    Future<void> refresh() async {
      switch (mode) {
        case PublicOrdersFeedMode.all:
          await ref.read(publicOrdersFeedControllerProvider.notifier).refresh();
          break;
        case PublicOrdersFeedMode.displayed:
          await ref
              .read(
                publicOrdersByStatusFeedControllerProvider(
                  'DISPLAYED',
                ).notifier,
              )
              .refresh();
          break;
        case PublicOrdersFeedMode.completed:
          await ref
              .read(
                publicOrdersByStatusFeedControllerProvider(
                  'COMPLETED',
                ).notifier,
              )
              .refresh();
          break;
        case PublicOrdersFeedMode.mine:
          ref.invalidate(myPublicOrdersProvider);
          ref.invalidate(myPublicOrdersCountProvider);
          break;
      }
    }

    Widget buildGrid({
      required List<PublicOrder> filtered,
      required bool isLoadingMore,
    }) {
      final extra = isLoadingMore ? 1 : 0;
      return GridView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: Responsive.paddingAll(context),
        itemCount: filtered.length + extra,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: context.hp(1.5),
          crossAxisSpacing: context.wp(3),
          childAspectRatio: 0.62,
        ),
        itemBuilder: (_, index) {
          if (index >= filtered.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return PublicOrderProduct(order: filtered[index]);
        },
      );
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: switch (mode) {
        PublicOrdersFeedMode.mine =>
          ref
              .watch(myPublicOrdersProvider)
              .when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: context.hp(15)),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(context.wp(4)),
                        child: Text(e.toString(), textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
                data: (orders) {
                  final filtered = query.isEmpty
                      ? orders
                      : orders.where((o) {
                          final t = o.title.toLowerCase();
                          final d = o.description.toLowerCase();
                          return t.contains(query) || d.contains(query);
                        }).toList();

                  if (filtered.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: context.hp(15)),
                        const Center(child: Text('No orders found')),
                      ],
                    );
                  }

                  return GridView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: Responsive.paddingAll(context),
                    itemCount: filtered.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: context.hp(1.5),
                      crossAxisSpacing: context.wp(3),
                      childAspectRatio: 0.62,
                    ),
                    itemBuilder: (_, index) =>
                        PublicOrderProduct(order: filtered[index]),
                  );
                },
              ),
        PublicOrdersFeedMode.all => _buildPaged(
          context,
          state: ref.watch(publicOrdersFeedControllerProvider),
          query: query,
          buildGrid: buildGrid,
        ),
        PublicOrdersFeedMode.displayed => _buildPaged(
          context,
          state: ref.watch(
            publicOrdersByStatusFeedControllerProvider('DISPLAYED'),
          ),
          query: query,
          buildGrid: buildGrid,
        ),
        PublicOrdersFeedMode.completed => _buildPaged(
          context,
          state: ref.watch(
            publicOrdersByStatusFeedControllerProvider('COMPLETED'),
          ),
          query: query,
          buildGrid: buildGrid,
        ),
      },
    );
  }

  Widget _buildPaged(
    BuildContext context, {
    required OrdersFeedState state,
    required String query,
    required Widget Function({
      required List<PublicOrder> filtered,
      required bool isLoadingMore,
    })
    buildGrid,
  }) {
    final items = state.items;
    final isLoading = state.isLoading;
    final isLoadingMore = state.isLoadingMore;
    final error = state.error;

    if (isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty && error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: context.hp(15)),
          Center(
            child: Padding(
              padding: EdgeInsets.all(context.wp(4)),
              child: Text(error.toString(), textAlign: TextAlign.center),
            ),
          ),
        ],
      );
    }

    final filtered = query.isEmpty
        ? items
        : items.where((o) {
            final t = o.title.toLowerCase();
            final d = o.description.toLowerCase();
            return t.contains(query) || d.contains(query);
          }).toList();

    if (filtered.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: context.hp(15)),
          const Center(child: Text('No orders found')),
        ],
      );
    }

    return buildGrid(filtered: filtered, isLoadingMore: isLoadingMore);
  }
}
