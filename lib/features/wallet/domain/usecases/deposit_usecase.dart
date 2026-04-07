import 'package:flutter_application_1/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:flutter_application_1/features/wallet/domain/repositories/wallet_repository.dart';

/// Use case to deposit to my wallet.
class DepositUseCase {
  final WalletRepository _repository;

  DepositUseCase(this._repository);

  Future<WalletTransaction> call(double amount, {String? description}) =>
      _repository.deposit(amount, description);
}
