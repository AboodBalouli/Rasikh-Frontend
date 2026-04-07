import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/colors.dart';

/// Action button for wallet operations.
class WalletActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const WalletActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: backgroundColor ?? TColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor ?? TColors.primary, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: TColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Row of wallet action buttons.
class WalletActionsRow extends StatelessWidget {
  final VoidCallback onDeposit;
  final VoidCallback onWithdraw;
  final VoidCallback onTransfer;

  const WalletActionsRow({
    super.key,
    required this.onDeposit,
    required this.onWithdraw,
    required this.onTransfer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          WalletActionButton(
            icon: Icons.add_circle_outline,
            label: 'إيداع',
            onTap: onDeposit,
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            iconColor: Colors.green,
          ),
          WalletActionButton(
            icon: Icons.remove_circle_outline,
            label: 'سحب',
            onTap: onWithdraw,
            backgroundColor: Colors.orange.withValues(alpha: 0.1),
            iconColor: Colors.orange,
          ),
          WalletActionButton(
            icon: Icons.swap_horiz,
            label: 'تحويل',
            onTap: onTransfer,
            backgroundColor: TColors.primary.withValues(alpha: 0.1),
            iconColor: TColors.primary,
          ),
        ],
      ),
    );
  }
}
