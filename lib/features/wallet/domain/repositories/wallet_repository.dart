import 'package:flutter_application_1/features/wallet/domain/entities/wallet.dart';
import 'package:flutter_application_1/features/wallet/domain/entities/wallet_transaction.dart';

/// Abstract repository contract for wallet feature.
abstract class WalletRepository {
  /// Get wallet by ID.
  Future<Wallet> getWallet(String walletId);

  /// Get wallet balance.
  Future<double> getWalletBalance(String walletId);

  /// Deposit to my wallet.
  Future<WalletTransaction> deposit(double amount, String? description);

  /// Withdraw from my wallet.
  Future<WalletTransaction> withdraw(double amount, String? description);

  /// Transfer to another wallet.
  Future<List<WalletTransaction>> transfer(
    String toWalletId,
    double amount,
    String? description,
  );

  /// Get my transactions.
  Future<List<WalletTransaction>> getMyTransactions();

  /// Get my transactions by date.
  Future<List<WalletTransaction>> getMyTransactionsByDate(DateTime date);
}
