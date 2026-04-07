import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/features/custom_orders/domain/entities/custom_order.dart';
import 'package:flutter_application_1/features/custom_orders/presentation/widgets/status_badge.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import 'package:intl/intl.dart';

/// Card widget displaying a custom order summary.
class CustomOrderCard extends StatelessWidget {
  final CustomOrder order;
  final VoidCallback? onTap;
  final bool showSellerInfo;

  const CustomOrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.showSellerInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.wp(4),
        vertical: context.hp(1),
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
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: Title + Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      order.title,
                      style: GoogleFonts.cairo(
                        fontSize: context.sp(16),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3748),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: context.wp(2)),
                  StatusBadge(status: order.status),
                ],
              ),
              SizedBox(height: context.hp(1)),

              // Description
              Text(
                order.description,
                style: GoogleFonts.cairo(
                  fontSize: context.sp(13),
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: context.hp(1.5)),

              // Quoted price if available
              if (order.quotedPrice != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.wp(3),
                    vertical: context.hp(0.8),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        size: context.sp(16),
                        color: const Color(0xFF388E3C),
                      ),
                      SizedBox(width: context.wp(1)),
                      Text(
                        '${order.quotedPrice!.toStringAsFixed(2)} JOD',
                        style: GoogleFonts.cairo(
                          fontSize: context.sp(14),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF388E3C),
                        ),
                      ),
                      if (order.estimatedDays != null) ...[
                        SizedBox(width: context.wp(3)),
                        Icon(
                          Icons.schedule,
                          size: context.sp(14),
                          color: const Color(0xFF388E3C),
                        ),
                        SizedBox(width: context.wp(0.5)),
                        Text(
                          '${order.estimatedDays} أيام',
                          style: GoogleFonts.cairo(
                            fontSize: context.sp(12),
                            color: const Color(0xFF388E3C),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: context.hp(1.5)),
              ],

              // Bottom row: Location + Date
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: context.sp(14),
                    color: Colors.grey[500],
                  ),
                  SizedBox(width: context.wp(0.5)),
                  Expanded(
                    child: Text(
                      order.location.isNotEmpty ? order.location : 'غير محدد',
                      style: GoogleFonts.cairo(
                        fontSize: context.sp(12),
                        color: Colors.grey[500],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.access_time,
                    size: context.sp(14),
                    color: Colors.grey[500],
                  ),
                  SizedBox(width: context.wp(0.5)),
                  Text(
                    _formatDate(order.createdAt),
                    style: GoogleFonts.cairo(
                      fontSize: context.sp(12),
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),

              // Show seller store name for customer view
              if (showSellerInfo && order.sellerStoreName != null) ...[
                SizedBox(height: context.hp(1)),
                Row(
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      size: context.sp(14),
                      color: const Color(0xFF53945D),
                    ),
                    SizedBox(width: context.wp(1)),
                    Text(
                      order.sellerStoreName!,
                      style: GoogleFonts.cairo(
                        fontSize: context.sp(12),
                        color: const Color(0xFF53945D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],

              // Show customer name for seller view
              if (!showSellerInfo && order.customerFullName.isNotEmpty) ...[
                SizedBox(height: context.hp(1)),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: context.sp(14),
                      color: const Color(0xFF53945D),
                    ),
                    SizedBox(width: context.wp(1)),
                    Text(
                      order.customerFullName,
                      style: GoogleFonts.cairo(
                        fontSize: context.sp(12),
                        color: const Color(0xFF53945D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'اليوم';
    } else if (diff.inDays == 1) {
      return 'أمس';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} أيام';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}
