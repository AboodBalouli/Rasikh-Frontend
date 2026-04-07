import 'package:flutter_application_1/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:flutter_application_1/features/wallet/domain/repositories/wallet_repository.dart';

/// Use case to withdraw from my wallet.
class WithdrawUseCase {
  final WalletRepository _repository;

  WithdrawUseCase(this._repository);

  Future<WalletTransaction> call(double amount, {String? description}) =>
      _repository.withdraw(amount, description);
}
