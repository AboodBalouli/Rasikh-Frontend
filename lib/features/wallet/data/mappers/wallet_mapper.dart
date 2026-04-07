import 'package:flutter_application_1/features/wallet/data/models/transaction_response_model.dart';
import 'package:flutter_application_1/features/wallet/data/models/wallet_response_model.dart';
import 'package:flutter_application_1/features/wallet/domain/entities/wallet.dart';
import 'package:flutter_application_1/features/wallet/domain/entities/wallet_transaction.dart';

/// Maps WalletResponseModel to Wallet entity.
Wallet mapWalletResponseToEntity(WalletResponseModel model) {
  return Wallet(id: model.id, walletId: model.walletId, balance: model.balance);
}

/// Maps TransactionResponseModel to WalletTransaction entity.
WalletTransaction mapTransactionResponseToEntity(
  TransactionResponseModel model,
) {
  return WalletTransaction(
    id: model.id,
    walletId: model.walletId,
    type: _parseTransactionType(model.type),
    date: model.date,
    time: model.time,
    amount: model.amount,
    description: model.description,
    receiver: model.receiver,
  );
}

TransactionType _parseTransactionType(String type) {
  switch (type.toUpperCase()) {
    case 'DEPOSIT':
      return TransactionType.deposit;
    case 'WITHDRAWAL':
      return TransactionType.withdrawal;
    case 'TRANSFER':
      return TransactionType.transfer;
    default:
      return TransactionType.unknown;
  }
}
