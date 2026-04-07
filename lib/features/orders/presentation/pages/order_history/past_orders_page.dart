import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/features/orders/presentation/providers/orders_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import '../../widgets/order_card.dart';
import 'package:go_router/go_router.dart';
import 'empty_orders_page.dart';

class PastOrdersPage extends ConsumerWidget {
  const PastOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(myOrdersProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'طلباتي السابقة',
          style: TextStyle(
            fontSize: context.sp(20),
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 83, 148, 93),
          ),
        ),
        leading: const CustomBackButton(),
        centerTitle: true,
      ),

      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) return const EmptyOrdersState();

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(myOrdersProvider),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: Responsive.paddingAll(context),
              itemCount: orders.length,
              separatorBuilder: (_, __) => SizedBox(height: context.hp(2)),
              itemBuilder: (context, index) {
                final order = orders[index];

                return OrderCard(
                  order: order,
                  onReorder: () {},
                  onRateTap: () async {
                    await context.push<int>(
                      '/rate-order',
                      extra: '${order.orderId}',
                    );
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: Responsive.paddingAll(context),
            child: Text(
              'حدث خطأ أثناء تحميل الطلبات: $error',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: context.sp(14)),
            ),
          ),
        ),
      ),
    );
  }
}
