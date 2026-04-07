import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/custom_orders/domain/entities/custom_order_status.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

/// Widget to display the status of a custom order with appropriate styling.
class StatusBadge extends StatelessWidget {
  final CustomOrderStatus status;
  final double? fontSize;

  const StatusBadge({super.key, required this.status, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.wp(3),
        vertical: context.hp(0.5),
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: fontSize ?? context.sp(12), color: _textColor),
          SizedBox(width: context.wp(1)),
          Text(
            status.displayNameAr,
            style: TextStyle(
              fontSize: fontSize ?? context.sp(12),
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }

  Color get _backgroundColor {
    switch (status) {
      case CustomOrderStatus.pending:
        return const Color(0xFFFFF3E0); // Orange light
      case CustomOrderStatus.quoted:
        return const Color(0xFFE3F2FD); // Blue light
      case CustomOrderStatus.accepted:
        return const Color(0xFFE8F5E9); // Green light
      case CustomOrderStatus.rejected:
        return const Color(0xFFFFEBEE); // Red light
      case CustomOrderStatus.canceled:
        return const Color(0xFFFAFAFA); // Gray light
    }
  }

  Color get _borderColor {
    switch (status) {
      case CustomOrderStatus.pending:
        return const Color(0xFFFFB74D); // Orange
      case CustomOrderStatus.quoted:
        return const Color(0xFF64B5F6); // Blue
      case CustomOrderStatus.accepted:
        return const Color(0xFF81C784); // Green
      case CustomOrderStatus.rejected:
        return const Color(0xFFE57373); // Red
      case CustomOrderStatus.canceled:
        return const Color(0xFFBDBDBD); // Gray
    }
  }

  Color get _textColor {
    switch (status) {
      case CustomOrderStatus.pending:
        return const Color(0xFFEF6C00); // Dark orange
      case CustomOrderStatus.quoted:
        return const Color(0xFF1976D2); // Dark blue
      case CustomOrderStatus.accepted:
        return const Color(0xFF388E3C); // Dark green
      case CustomOrderStatus.rejected:
        return const Color(0xFFD32F2F); // Dark red
      case CustomOrderStatus.canceled:
        return const Color(0xFF757575); // Dark gray
    }
  }

  IconData get _icon {
    switch (status) {
      case CustomOrderStatus.pending:
        return Icons.hourglass_empty;
      case CustomOrderStatus.quoted:
        return Icons.attach_money;
      case CustomOrderStatus.accepted:
        return Icons.check_circle_outline;
      case CustomOrderStatus.rejected:
        return Icons.cancel_outlined;
      case CustomOrderStatus.canceled:
        return Icons.block_outlined;
    }
  }
}
