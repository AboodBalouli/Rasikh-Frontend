/// Domain entity for a wallet.
class Wallet {
  final int id;
  final String walletId;
  final double balance;

  const Wallet({
    required this.id,
    required this.walletId,
    required this.balance,
  });

  /// Format balance as currency string.
  String get formattedBalance => '${balance.toStringAsFixed(2)} د.أ';
}
