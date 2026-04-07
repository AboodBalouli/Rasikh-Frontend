import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/providers/custom_orders_providers.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/widgets/custom_order_card.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import 'package:flutter_application_1/features/custom_orders/domain/entities/custom_order_status.dart';

/// Page showing seller's inbox of custom order requests.
class SellerInboxPage extends ConsumerStatefulWidget {
  const SellerInboxPage({super.key});

  @override
  ConsumerState<SellerInboxPage> createState() => _SellerInboxPageState();
}

class _SellerInboxPageState extends ConsumerState<SellerInboxPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() => ref.read(sellerInboxControllerProvider).loadInbox());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(sellerInboxControllerProvider).loadInbox();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(sellerInboxControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(
          'طلبات العملاء',
          style: TextStyle(
            fontSize: context.sp(20),
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 83, 148, 93),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF53945D),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF53945D),
          labelStyle: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: context.sp(13),
          ),
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('قيد الانتظار'),
                  if (controller.pendingCount > 0) ...[
                    SizedBox(width: context.wp(1)),
                    Container(
                      padding: EdgeInsets.all(context.wp(1.5)),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF6C00),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${controller.pendingCount}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: context.sp(10),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(text: 'تم التسعير'),
            const Tab(text: 'مكتملة'),
          ],
        ),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.error != null
          ? _buildError(controller.error!)
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(
                  controller.inbox
                      .where((o) => o.status == CustomOrderStatus.pending)
                      .toList(),
                ),
                _buildOrderList(
                  controller.inbox
                      .where((o) => o.status == CustomOrderStatus.quoted)
                      .toList(),
                ),
                _buildOrderList(
                  controller.inbox.where((o) => o.status.isFinal).toList(),
                ),
              ],
            ),
    );
  }

  Widget _buildOrderList(List orders) {
    if (orders.isEmpty) {
      return _buildEmpty();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: context.hp(1)),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return CustomOrderCard(
            order: order,
            showSellerInfo: false,
            onTap: () {
              ref.read(sellerInboxControllerProvider).selectOrder(order);
              if (order.canQuote) {
                context.push('/quote-order/${order.id}');
              } else {
                context.push('/custom-order-detail/${order.id}');
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(context.wp(6)),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: context.sp(50),
              color: const Color(0xFF53945D),
            ),
          ),
          SizedBox(height: context.hp(3)),
          Text(
            'لا توجد طلبات',
            style: GoogleFonts.cairo(
              fontSize: context.sp(18),
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: context.hp(1)),
          Text(
            'ستظهر هنا طلبات العملاء الخاصة',
            style: GoogleFonts.cairo(
              fontSize: context.sp(14),
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: Responsive.paddingAll(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: context.sp(50),
              color: Colors.red[300],
            ),
            SizedBox(height: context.hp(2)),
            Text(
              'حدث خطأ',
              style: GoogleFonts.cairo(
                fontSize: context.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.hp(1)),
            Text(
              error,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(fontSize: context.sp(13)),
            ),
            SizedBox(height: context.hp(3)),
            ElevatedButton.icon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh),
              label: Text('إعادة المحاولة', style: GoogleFonts.cairo()),
            ),
          ],
        ),
      ),
    );
  }
}
