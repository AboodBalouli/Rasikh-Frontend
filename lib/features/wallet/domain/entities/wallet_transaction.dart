/// Transaction types.
enum TransactionType { deposit, withdrawal, transfer, unknown }

/// Domain entity for a wallet transaction.
class WalletTransaction {
  final int id;
  final String? walletId;
  final TransactionType type;
  final DateTime? date;
  final String? time;
  final double amount;
  final String? description;
  final String? receiver;

  const WalletTransaction({
    required this.id,
    this.walletId,
    required this.type,
    this.date,
    this.time,
    required this.amount,
    this.description,
    this.receiver,
  });

  /// Format amount as currency string.
  String get formattedAmount => '${amount.toStringAsFixed(2)} د.أ';

  /// Get display-friendly type name in Arabic.
  String get typeDisplayName {
    switch (type) {
      case TransactionType.deposit:
        return 'إيداع';
      case TransactionType.withdrawal:
        return 'سحب';
      case TransactionType.transfer:
        return 'تحويل';
      case TransactionType.unknown:
        return 'غير معروف';
    }
  }

  /// Get formatted date string.
  String get formattedDate {
    if (date == null) return '';
    return '${date!.day}/${date!.month}/${date!.year}';
  }

  /// Whether this is a credit (deposit) transaction.
  bool get isCredit => type == TransactionType.deposit;

  /// Whether this is a debit (withdrawal/transfer) transaction.
  bool get isDebit =>
      type == TransactionType.withdrawal || type == TransactionType.transfer;
}
