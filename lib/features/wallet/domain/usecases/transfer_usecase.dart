import 'package:flutter_application_1/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:flutter_application_1/features/wallet/domain/repositories/wallet_repository.dart';

/// Use case to transfer to another wallet.
class TransferUseCase {
  final WalletRepository _repository;

  TransferUseCase(this._repository);

  Future<List<WalletTransaction>> call(
    String toWalletId,
    double amount, {
    String? description,
  }) => _repository.transfer(toWalletId, amount, description);
}
