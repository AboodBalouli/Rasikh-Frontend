import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/providers/custom_orders_providers.dart';
import 'package:flutter_application_1/features/custom_orders/domain/entities/custom_order.dart';
import 'package:flutter_application_1/features/custom_orders/domain/entities/custom_order_status.dart';
import 'package:flutter_application_1/features/user_profile/presentation/providers/profile_providers.dart';
import 'package:intl/intl.dart';

/// Notifications page that displays order updates and notifications.
class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  bool _isSeller = false;

  @override
  void initState() {
    super.initState();
    // Load profile first to determine if user is seller, then load orders
    Future.microtask(() async {
      await _loadProfileAndOrders();
    });
  }

  Future<void> _loadProfileAndOrders() async {
    // Load profile to check if user is a seller
    final storeController = ref.read(storeSettingsControllerProvider);
    await storeController.load();

    // Check if user has an actual store with a name (making them a seller)
    // Regular users might have an empty store object, so check storeName
    final profile = storeController.profile;
    final hasStore =
        profile?.store?.storeName != null &&
        profile!.store!.storeName!.isNotEmpty;

    if (mounted) {
      setState(() {
        _isSeller = hasStore;
      });
    }

    // Load orders from the appropriate endpoint based on role
    if (_isSeller) {
      await ref.read(sellerInboxControllerProvider).loadInbox();
    } else {
      await ref.read(customOrdersControllerProvider).loadMyOrders();
    }
  }

  Future<void> _onRefresh() async {
    if (_isSeller) {
      await ref.read(sellerInboxControllerProvider).loadInbox();
    } else {
      await ref.read(customOrdersControllerProvider).loadMyOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get orders from the appropriate controller based on role
    List<CustomOrder> allOrders;
    bool isLoading;

    if (_isSeller) {
      final sellerController = ref.watch(sellerInboxControllerProvider);
      allOrders = sellerController.inbox;
      isLoading = sellerController.isLoading;
    } else {
      final customerController = ref.watch(customOrdersControllerProvider);
      allOrders = customerController.orders;
      isLoading = customerController.isLoading;
    }

    // For customers: show ALL their orders (طلباتي الخاصة)
    // For sellers: show all inbox orders
    final notifications = allOrders.toList()
      ..sort(
        (a, b) =>
            b.updatedAt?.compareTo(a.updatedAt ?? a.createdAt) ??
            b.createdAt.compareTo(a.createdAt),
      );

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(
          _isSeller ? 'طلبات مخصصة واردة' : 'الإشعارات',
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? _buildEmptyState(context)
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: context.hp(1)),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return _NotificationCard(
                    order: notifications[index],
                    isSeller: _isSeller,
                    onTap: () => context.push(
                      '/custom-order-detail/${notifications[index].id}',
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(context.wp(6)),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: context.sp(50),
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: context.hp(3)),
          Text(
            'لا توجد إشعارات',
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
              'ستظهر هنا تحديثات طلباتك الخاصة',
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
}

/// Individual notification card widget.
class _NotificationCard extends StatelessWidget {
  final CustomOrder order;
  final VoidCallback onTap;
  final bool isSeller;

  const _NotificationCard({
    required this.order,
    required this.onTap,
    this.isSeller = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.wp(4),
        vertical: context.hp(0.8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(context.wp(4)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: _borderColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(context.wp(3)),
                decoration: BoxDecoration(
                  color: _iconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, color: _iconColor, size: context.sp(22)),
              ),
              SizedBox(width: context.wp(3)),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title,
                      style: GoogleFonts.cairo(
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: context.hp(0.5)),
                    Text(
                      order.title,
                      style: GoogleFonts.cairo(
                        fontSize: context.sp(13),
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (order.quotedPrice != null &&
                        order.status == CustomOrderStatus.quoted) ...[
                      SizedBox(height: context.hp(0.8)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.wp(2.5),
                          vertical: context.hp(0.3),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${order.quotedPrice!.toStringAsFixed(2)} JOD',
                          style: GoogleFonts.cairo(
                            fontSize: context.sp(12),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF388E3C),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Time
              Text(
                _formatTime(order.updatedAt ?? order.createdAt),
                style: GoogleFonts.cairo(
                  fontSize: context.sp(11),
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _title {
    if (isSeller) {
      // Seller-specific messages - show customer name
      final customerName = order.customerFullName.isNotEmpty
          ? order.customerFullName
          : 'عميل';
      switch (order.status) {
        case CustomOrderStatus.pending:
          return 'لديك طلب من $customerName 📩';
        case CustomOrderStatus.quoted:
          return 'تم تسعير طلب $customerName ✓';
        case CustomOrderStatus.accepted:
          return '$customerName قبل عرضك 🎉';
        case CustomOrderStatus.rejected:
          return 'رفضت طلب $customerName';
        default:
          return 'طلب من $customerName';
      }
    } else {
      // Customer-specific messages - their own orders
      switch (order.status) {
        case CustomOrderStatus.pending:
          return 'طلبك قيد الانتظار ⏳';
        case CustomOrderStatus.quoted:
          return 'تم تسعير طلبك 💰';
        case CustomOrderStatus.accepted:
          return 'تم قبول الطلب ✅';
        case CustomOrderStatus.rejected:
          return 'تم رفض الطلب ❌';
        case CustomOrderStatus.canceled:
          return 'تم إلغاء الطلب';
        default:
          return 'طلبك الخاص';
      }
    }
  }

  IconData get _icon {
    switch (order.status) {
      case CustomOrderStatus.quoted:
        return Icons.attach_money;
      case CustomOrderStatus.accepted:
        return Icons.check_circle;
      case CustomOrderStatus.rejected:
        return Icons.cancel;
      default:
        return Icons.notifications;
    }
  }

  Color get _iconColor {
    switch (order.status) {
      case CustomOrderStatus.quoted:
        return const Color(0xFF1976D2);
      case CustomOrderStatus.accepted:
        return const Color(0xFF388E3C);
      case CustomOrderStatus.rejected:
        return const Color(0xFFD32F2F);
      default:
        return Colors.grey;
    }
  }

  Color get _iconBackgroundColor {
    switch (order.status) {
      case CustomOrderStatus.quoted:
        return const Color(0xFFE3F2FD);
      case CustomOrderStatus.accepted:
        return const Color(0xFFE8F5E9);
      case CustomOrderStatus.rejected:
        return const Color(0xFFFFEBEE);
      default:
        return Colors.grey[100]!;
    }
  }

  Color get _borderColor {
    switch (order.status) {
      case CustomOrderStatus.quoted:
        return const Color(0xFF64B5F6);
      case CustomOrderStatus.accepted:
        return const Color(0xFF81C784);
      case CustomOrderStatus.rejected:
        return const Color(0xFFE57373);
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays == 1) {
      return 'أمس';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} أيام';
    } else {
      return DateFormat('dd/MM').format(date);
    }
  }
}
