import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/providers/custom_orders_providers.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/widgets/custom_order_card.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

/// Page showing customer's custom order requests.
class MyCustomOrdersPage extends ConsumerStatefulWidget {
  const MyCustomOrdersPage({super.key});

  @override
  ConsumerState<MyCustomOrdersPage> createState() => _MyCustomOrdersPageState();
}

class _MyCustomOrdersPageState extends ConsumerState<MyCustomOrdersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(customOrdersControllerProvider).loadMyOrders(),
    );
  }

  Future<void> _onRefresh() async {
    await ref.read(customOrdersControllerProvider).loadMyOrders();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(customOrdersControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(
          'طلباتي الخاصة',
          style: TextStyle(
            fontSize: context.sp(20),
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 83, 148, 93),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.error != null
          ? _buildError(controller.error!)
          : controller.orders.isEmpty
          ? _buildEmpty()
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: context.hp(1)),
                itemCount: controller.orders.length,
                itemBuilder: (context, index) {
                  final order = controller.orders[index];
                  return CustomOrderCard(
                    order: order,
                    showSellerInfo: true,
                    onTap: () =>
                        context.push('/custom-order-detail/${order.id}'),
                  );
                },
              ),
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
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
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
            'لا توجد طلبات خاصة',
            style: GoogleFonts.cairo(
              fontSize: context.sp(18),
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: context.hp(1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.wp(10)),
            child: Text(
              'يمكنك إنشاء طلب خاص من صفحة أي متجر',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: context.sp(14),
                color: Colors.grey[500],
              ),
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
              'حدث خطأ أثناء التحميل',
              style: GoogleFonts.cairo(
                fontSize: context.sp(16),
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: context.hp(1)),
            Text(
              error,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: context.sp(13),
                color: Colors.grey[500],
              ),
            ),
            SizedBox(height: context.hp(3)),
            ElevatedButton.icon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh),
              label: Text('إعادة المحاولة', style: GoogleFonts.cairo()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF53945D),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: context.wp(6),
                  vertical: context.hp(1.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
