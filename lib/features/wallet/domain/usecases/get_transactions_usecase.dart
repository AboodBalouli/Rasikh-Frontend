import 'package:flutter_application_1/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:flutter_application_1/features/wallet/domain/repositories/wallet_repository.dart';

/// Use case to get my transactions.
class GetMyTransactionsUseCase {
  final WalletRepository _repository;

  GetMyTransactionsUseCase(this._repository);

  Future<List<WalletTransaction>> call() => _repository.getMyTransactions();
}

/// Use case to get my transactions by date.
class GetMyTransactionsByDateUseCase {
  final WalletRepository _repository;

  GetMyTransactionsByDateUseCase(this._repository);

  Future<List<WalletTransaction>> call(DateTime date) =>
      _repository.getMyTransactionsByDate(date);
}
