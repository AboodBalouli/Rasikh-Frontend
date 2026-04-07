import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/features/wallet/domain/entities/wallet_transaction.dart';

/// Widget for displaying a single transaction item.
class TransactionListItem extends StatelessWidget {
  final WalletTransaction transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Transaction type icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getIconBackgroundColor(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getTransactionIcon(),
              color: _getIconColor(),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.typeDisplayName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: TColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.description ?? transaction.formattedDate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: TColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.isCredit ? '+' : '-'}${transaction.formattedAmount}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: transaction.isCredit ? Colors.green : Colors.red,
                ),
              ),
              if (transaction.time != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    transaction.time!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: TColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getTransactionIcon() {
    switch (transaction.type) {
      case TransactionType.deposit:
        return Icons.arrow_downward;
      case TransactionType.withdrawal:
        return Icons.arrow_upward;
      case TransactionType.transfer:
        return Icons.swap_horiz;
      case TransactionType.unknown:
        return Icons.help_outline;
    }
  }

  Color _getIconColor() {
    switch (transaction.type) {
      case TransactionType.deposit:
        return Colors.green;
      case TransactionType.withdrawal:
        return Colors.orange;
      case TransactionType.transfer:
        return TColors.primary;
      case TransactionType.unknown:
        return Colors.grey;
    }
  }

  Color _getIconBackgroundColor() {
    return _getIconColor().withValues(alpha: 0.1);
  }
}
