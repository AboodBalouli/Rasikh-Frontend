import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/providers/custom_orders_providers.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/widgets/status_badge.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/widgets/image_gallery.dart';
import 'package:flutter_application_1/features/custom_orders/domain/entities/custom_order.dart';
import 'package:flutter_application_1/features/custom_orders/domain/entities/custom_order_status.dart';
import 'package:flutter_application_1/features/user_profile/presentation/providers/profile_providers.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import 'package:intl/intl.dart';

/// Page showing detailed view of a custom order.
class CustomOrderDetailPage extends ConsumerStatefulWidget {
  final String orderId;

  const CustomOrderDetailPage({super.key, required this.orderId});

  @override
  ConsumerState<CustomOrderDetailPage> createState() =>
      _CustomOrderDetailPageState();
}

class _CustomOrderDetailPageState extends ConsumerState<CustomOrderDetailPage> {
  bool _isSeller = false;
  CustomOrder? _order;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _loadProfileAndOrder();
    });
  }

  Future<void> _loadProfileAndOrder() async {
    setState(() => _isLoading = true);

    // First, check if user is a seller (has actual store with name)
    final storeController = ref.read(storeSettingsControllerProvider);
    await storeController.load();

    final profile = storeController.profile;
    final isSeller =
        profile?.store?.storeName != null &&
        profile!.store!.storeName!.isNotEmpty;

    if (mounted) {
      setState(() => _isSeller = isSeller);
    }

    // Load order from appropriate source
    if (isSeller) {
      // Seller: load from seller inbox controller
      final sellerController = ref.read(sellerInboxControllerProvider);
      await sellerController.loadInbox();
      final order = sellerController.inbox.cast<CustomOrder?>().firstWhere(
        (o) => o?.id.toString() == widget.orderId,
        orElse: () => null,
      );
      if (mounted) {
        setState(() {
          _order = order;
          _isLoading = false;
        });
      }
    } else {
      // Customer: load from custom orders controller
      await ref
          .read(customOrdersControllerProvider)
          .loadOrderById(widget.orderId);
      if (mounted) {
        setState(() {
          _order = ref.read(customOrdersControllerProvider).selectedOrder;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _acceptQuote() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'قبول التسعير',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'هل تريد قبول هذا التسعير؟ لا يمكن التراجع بعد القبول.',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(false),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          TextButton(
            onPressed: () => ctx.pop(true),
            child: Text(
              'قبول',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await ref
        .read(customOrdersControllerProvider)
        .acceptOrderQuote(widget.orderId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم قبول التسعير بنجاح', style: GoogleFonts.cairo()),
          backgroundColor: const Color(0xFF53945D),
        ),
      );
    }
  }

  /// Customer action to delete their order
  Future<void> _deleteOrder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'حذف الطلب',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'هل أنت متأكد من حذف هذا الطلب؟ لا يمكن التراجع بعد الحذف.',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(false),
            child: Text('تراجع', style: GoogleFonts.cairo()),
          ),
          TextButton(
            onPressed: () => ctx.pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(
              'حذف',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await ref
        .read(customOrdersControllerProvider)
        .cancel(widget.orderId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حذف الطلب', style: GoogleFonts.cairo()),
          backgroundColor: Colors.red,
        ),
      );
      context.pop();
    }
  }

  /// Seller action to reject an order
  Future<void> _rejectOrder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'رفض الطلب',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'هل أنت متأكد من رفض هذا الطلب؟ لا يمكن التراجع بعد الرفض.',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(false),
            child: Text('تراجع', style: GoogleFonts.cairo()),
          ),
          TextButton(
            onPressed: () => ctx.pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(
              'رفض',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await ref
        .read(sellerInboxControllerProvider)
        .reject(widget.orderId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم رفض الطلب', style: GoogleFonts.cairo()),
          backgroundColor: Colors.red,
        ),
      );
      context.pop();
    }
  }

  Future<void> _openWhatsApp(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(customOrdersControllerProvider);
    final order = _order;

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(
          'تفاصيل الطلب',
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : order == null
          ? _buildError('لم يتم العثور على الطلب')
          : SingleChildScrollView(
              padding: Responsive.paddingAll(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status + Title header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          order.title,
                          style: GoogleFonts.cairo(
                            fontSize: context.sp(22),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      StatusBadge(
                        status: order.status,
                        fontSize: context.sp(13),
                      ),
                    ],
                  ),
                  SizedBox(height: context.hp(2)),

                  // Description
                  _buildSection(
                    context,
                    icon: Icons.description_outlined,
                    title: 'الوصف',
                    child: Text(
                      order.description,
                      style: GoogleFonts.cairo(
                        fontSize: context.sp(14),
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                  ),

                  // Images Gallery
                  if (order.imageUrls.isNotEmpty) ...[
                    SizedBox(height: context.hp(2)),
                    _buildSection(
                      context,
                      icon: Icons.photo_library_outlined,
                      title: 'الصور',
                      child: ImageGallery(
                        imageUrls: order.imageUrls,
                        crossAxisCount: 3,
                      ),
                    ),
                  ],
                  if (order.quotedPrice != null) ...[
                    SizedBox(height: context.hp(2)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(context.wp(4)),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF53945D).withOpacity(0.1),
                            const Color(0xFF53945D).withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF53945D).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_offer_outlined,
                                color: const Color(0xFF53945D),
                                size: context.sp(20),
                              ),
                              SizedBox(width: context.wp(2)),
                              Text(
                                'عرض السعر',
                                style: GoogleFonts.cairo(
                                  fontSize: context.sp(16),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF53945D),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.hp(2)),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'السعر',
                                      style: GoogleFonts.cairo(
                                        fontSize: context.sp(12),
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      '${order.quotedPrice!.toStringAsFixed(2)} JOD',
                                      style: GoogleFonts.cairo(
                                        fontSize: context.sp(20),
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF2D3748),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (order.estimatedDays != null)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'مدة التوصيل',
                                        style: GoogleFonts.cairo(
                                          fontSize: context.sp(12),
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        '${order.estimatedDays} أيام',
                                        style: GoogleFonts.cairo(
                                          fontSize: context.sp(20),
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF2D3748),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          if (order.sellerNote != null &&
                              order.sellerNote!.isNotEmpty) ...[
                            SizedBox(height: context.hp(2)),
                            Text(
                              'ملاحظة البائع:',
                              style: GoogleFonts.cairo(
                                fontSize: context.sp(13),
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              order.sellerNote!,
                              style: GoogleFonts.cairo(
                                fontSize: context.sp(13),
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: context.hp(2)),

                  // Contact info
                  _buildSection(
                    context,
                    icon: Icons.contact_phone_outlined,
                    title: 'معلومات التواصل',
                    child: Column(
                      children: [
                        _buildInfoRow(
                          context,
                          Icons.location_on_outlined,
                          'الموقع',
                          order.location,
                        ),
                        SizedBox(height: context.hp(1)),
                        _buildInfoRow(
                          context,
                          Icons.phone_outlined,
                          'الهاتف',
                          order.phoneNumber,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: context.hp(2)),

                  // Date info
                  _buildSection(
                    context,
                    icon: Icons.calendar_today_outlined,
                    title: 'التواريخ',
                    child: Column(
                      children: [
                        _buildInfoRow(
                          context,
                          Icons.add_circle_outline,
                          'تاريخ الإنشاء',
                          DateFormat(
                            'dd/MM/yyyy - HH:mm',
                          ).format(order.createdAt),
                        ),
                        if (order.updatedAt != null) ...[
                          SizedBox(height: context.hp(1)),
                          _buildInfoRow(
                            context,
                            Icons.update,
                            'آخر تحديث',
                            DateFormat(
                              'dd/MM/yyyy - HH:mm',
                            ).format(order.updatedAt!),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: context.hp(4)),

                  // SELLER Action buttons - Quote and Reject for pending orders
                  if (_isSeller && order.status.canQuote) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                context.push('/quote-order/${order.id}'),
                            icon: const Icon(Icons.attach_money),
                            label: Text(
                              'تسعير الطلب',
                              style: GoogleFonts.cairo(
                                fontSize: context.sp(15),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF53945D),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: context.hp(1.8),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: context.wp(3)),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _rejectOrder(),
                            icon: const Icon(Icons.close, color: Colors.red),
                            label: Text(
                              'رفض الطلب',
                              style: GoogleFonts.cairo(
                                fontSize: context.sp(15),
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: EdgeInsets.symmetric(
                                vertical: context.hp(1.8),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.hp(2)),
                  ],

                  // CUSTOMER Action buttons - Accept Quote
                  if (!_isSeller && order.canAcceptQuote) ...[
                    SizedBox(
                      width: double.infinity,
                      height: context.hp(7),
                      child: ElevatedButton.icon(
                        onPressed: controller.isSaving ? null : _acceptQuote,
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text(
                          'قبول التسعير',
                          style: GoogleFonts.cairo(
                            fontSize: context.sp(16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF53945D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.hp(2)),
                  ],

                  // SELLER: Contact customer buttons
                  if (_isSeller) ...[
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _callPhone(order.phoneNumber),
                            icon: const Icon(Icons.phone),
                            label: Text(
                              'اتصال بالعميل',
                              style: GoogleFonts.cairo(),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: context.hp(1.5),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: context.wp(3)),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: order.whatsappUrl.isNotEmpty
                                ? () => _openWhatsApp(order.whatsappUrl)
                                : null,
                            icon: const Icon(Icons.chat),
                            label: Text('واتساب', style: GoogleFonts.cairo()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: context.hp(1.5),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // CUSTOMER: Delete order button
                  if (!_isSeller && order.canCancel) ...[
                    SizedBox(height: context.hp(3)),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: controller.isSaving ? null : _deleteOrder,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: EdgeInsets.symmetric(
                            vertical: context.hp(1.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        label: Text(
                          'حذف الطلب',
                          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.wp(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF53945D), size: context.sp(20)),
              SizedBox(width: context.wp(2)),
              Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: context.sp(15),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF53945D),
                ),
              ),
            ],
          ),
          SizedBox(height: context.hp(1.5)),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: context.sp(16), color: Colors.grey[500]),
        SizedBox(width: context.wp(2)),
        Text(
          '$label: ',
          style: GoogleFonts.cairo(
            fontSize: context.sp(13),
            color: Colors.grey[600],
          ),
        ),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : 'غير محدد',
            style: GoogleFonts.cairo(
              fontSize: context.sp(13),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3748),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Text(
        error,
        style: GoogleFonts.cairo(fontSize: context.sp(16), color: Colors.grey),
      ),
    );
  }
}
