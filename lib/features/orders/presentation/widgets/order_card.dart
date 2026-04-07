import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/utils/helpers/helper_functions.dart';
import 'package:flutter_application_1/features/orders/domain/entities/order.dart';
import 'package:flutter_application_1/features/orders/domain/entities/order_status.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import 'order_chip.dart';
import 'order_rating.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  /// callbacks
  final VoidCallback onRateTap;
  final VoidCallback onReorder;

  const OrderCard({
    super.key,
    required this.order,
    required this.onRateTap,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final createdText = HelperFunctions.timeAgo(order.createdAt);

    return Container(
      padding: EdgeInsets.all(context.wp(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                createdText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontSize: context.sp(12),
                ),
              ),
              OrderStatusChip(status: order.status),
            ],
          ),

          SizedBox(height: context.hp(1.5)),

          Row(
            children: [
              CircleAvatar(
                radius: context.sp(22),
                child: Icon(Icons.receipt_long_outlined, size: context.sp(24)),
              ),
              SizedBox(width: context.wp(3)),
              Expanded(
                child: Text(
                  'طلب #${order.orderId}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: context.sp(16),
                  ),
                ),
              ),
              Text(
                '${order.totalItems} عنصر',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontSize: context.sp(12),
                ),
              ),
            ],
          ),

          Divider(height: context.hp(4)),

          Column(
            children: order.items.map((item) {
              final String imageUrl = item.productImagePath.startsWith('/')
                  ? '${AppConfig.apiBaseUrl}${item.productImagePath}'
                  : item.productImagePath;

              return Padding(
                padding: EdgeInsets.only(bottom: context.hp(1.5)),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        width: context.wp(14),
                        height: context.wp(14),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: context.wp(14),
                            height: context.wp(14),
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: context.wp(3)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: TextStyle(fontSize: context.sp(14)),
                          ),
                          Text(
                            '${item.quantity} × ${item.price}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                              fontSize: context.sp(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الإجمالي', style: TextStyle(fontSize: context.sp(14))),
              Text(
                order.totalAmount.toStringAsFixed(2),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: context.sp(16),
                ),
              ),
            ],
          ),

          SizedBox(height: context.hp(2)),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color.fromARGB(255, 193, 189, 162).withOpacity(0.2),
                      const Color.fromARGB(255, 118, 81, 58).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    onPressed: onReorder,
                    padding: EdgeInsets.symmetric(vertical: context.hp(1.5)),
                    child: Text(
                      'اطلب مجددًا',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w600,
                        fontSize: context.sp(16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: context.hp(1.5)),

          if (order.status == OrderStatus.completed) ...[
            SizedBox(height: context.hp(1.5)),
            OrderRating(
              rating: 0,
              onTap: onRateTap,
            ), // Might need responsiveness here too, but OrderRating might be a simple row of stars.
          ],
        ],
      ),
    );
  }
}
