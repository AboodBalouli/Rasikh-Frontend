import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/orders/domain/entities/order_status.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late String text;
    late Color color;

    switch (status) {
      case OrderStatus.pending:
        text = 'قيد الانتظار';
        color = Colors.orange;
        break;
      case OrderStatus.paid:
        text = 'مدفوع';
        color = Colors.blue;
        break;
      case OrderStatus.shipped:
        text = 'تم الشحن';
        color = Colors.purple;
        break;
      case OrderStatus.completed:
        text = 'مكتمل';
        color = Colors.green;
        break;
      case OrderStatus.canceled:
        text = 'ملغي';
        color = Colors.red;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.wp(3),
        vertical: context.hp(0.8),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: context.sp(12)),
      ),
    );
  }
}
