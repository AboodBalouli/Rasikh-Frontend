import 'package:flutter_application_1/features/wallet/domain/entities/wallet.dart';
import 'package:flutter_application_1/features/wallet/domain/repositories/wallet_repository.dart';

/// Use case to get wallet by ID.
class GetWalletUseCase {
  final WalletRepository _repository;

  GetWalletUseCase(this._repository);

  Future<Wallet> call(String walletId) => _repository.getWallet(walletId);
}
