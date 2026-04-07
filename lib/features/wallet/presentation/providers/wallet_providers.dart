import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/app/dependency_injection/wallet_dependency_injection.dart';
import 'package:flutter_application_1/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:flutter_application_1/features/wallet/domain/usecases/deposit_usecase.dart';
import 'package:flutter_application_1/features/wallet/domain/usecases/get_transactions_usecase.dart';
import 'package:flutter_application_1/features/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:flutter_application_1/features/wallet/domain/usecases/transfer_usecase.dart';
import 'package:flutter_application_1/features/wallet/domain/usecases/withdraw_usecase.dart';
import 'package:flutter_riverpod/legacy.dart';

// ==================== Use Case Providers ====================

/// Provider for GetWalletUseCase.
final getWalletUseCaseProvider = Provider<GetWalletUseCase>((ref) {
  final repo = ref.watch(walletRepositoryProvider);
  return GetWalletUseCase(repo);
});

/// Provider for DepositUseCase.
final depositUseCaseProvider = Provider<DepositUseCase>((ref) {
  final repo = ref.watch(walletRepositoryProvider);
  return DepositUseCase(repo);
});

/// Provider for WithdrawUseCase.
final withdrawUseCaseProvider = Provider<WithdrawUseCase>((ref) {
  final repo = ref.watch(walletRepositoryProvider);
  return WithdrawUseCase(repo);
});

/// Provider for TransferUseCase.
final transferUseCaseProvider = Provider<TransferUseCase>((ref) {
  final repo = ref.watch(walletRepositoryProvider);
  return TransferUseCase(repo);
});

/// Provider for GetMyTransactionsUseCase.
final getMyTransactionsUseCaseProvider = Provider<GetMyTransactionsUseCase>((
  ref,
) {
  final repo = ref.watch(walletRepositoryProvider);
  return GetMyTransactionsUseCase(repo);
});

// ==================== Data Providers ====================

/// Provider for my transactions.
final myTransactionsProvider = FutureProvider<List<WalletTransaction>>((
  ref,
) async {
  final usecase = ref.watch(getMyTransactionsUseCaseProvider);
  return usecase();
});

/// Provider to reload wallet data.
final walletRefreshProvider = StateProvider<int>((ref) => 0);

/// Provider for my wallet balance from user profile.
/// We use the walletId from the user profile to fetch wallet details.
final myWalletBalanceProvider = FutureProvider<double>((ref) async {
  // Watch refresh trigger to allow manual refresh
  ref.watch(walletRefreshProvider);
  final repo = ref.watch(walletRepositoryProvider);
  final transactions = await repo.getMyTransactions();
  // Derive balance from transaction history or return 0
  // Actually we need to fetch wallet directly - but we need walletId
  // For now, return calculated balance
  double balance = 0;
  for (final tx in transactions) {
    if (tx.isCredit) {
      balance += tx.amount;
    } else {
      balance -= tx.amount;
    }
  }
  return balance;
});
