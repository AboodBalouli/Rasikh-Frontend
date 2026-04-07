import 'package:flutter_application_1/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_1/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:flutter_application_1/features/wallet/data/mappers/wallet_mapper.dart';
import 'package:flutter_application_1/features/wallet/data/models/amount_request_model.dart';
import 'package:flutter_application_1/features/wallet/data/models/transfer_request_model.dart';
import 'package:flutter_application_1/features/wallet/domain/entities/wallet.dart';
import 'package:flutter_application_1/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:flutter_application_1/features/wallet/domain/repositories/wallet_repository.dart';

/// Implementation of WalletRepository using remote datasource.
class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDatasource _datasource;
  final AuthLocalDataSource _authLocalDataSource;

  WalletRepositoryImpl({
    required WalletRemoteDatasource datasource,
    AuthLocalDataSource? authLocalDataSource,
  }) : _datasource = datasource,
       _authLocalDataSource = authLocalDataSource ?? AuthLocalDataSource();

  Future<String> _getToken() async {
    final token = await _authLocalDataSource.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    return token;
  }

  @override
  Future<Wallet> getWallet(String walletId) async {
    final token = await _getToken();
    final response = await _datasource.getWallet(walletId, token);
    if (!response.success || response.data == null) {
      throw Exception(response.error?.message ?? 'Failed to fetch wallet');
    }
    return mapWalletResponseToEntity(response.data!);
  }

  @override
  Future<double> getWalletBalance(String walletId) async {
    final token = await _getToken();
    final response = await _datasource.getWalletBalance(walletId, token);
    if (!response.success || response.data == null) {
      throw Exception(response.error?.message ?? 'Failed to fetch balance');
    }
    return response.data!;
  }

  @override
  Future<WalletTransaction> deposit(double amount, String? description) async {
    final token = await _getToken();
    final request = AmountRequestModel(
      amount: amount,
      description: description,
    );
    final response = await _datasource.deposit(request, token);
    if (!response.success || response.data == null) {
      throw Exception(response.error?.message ?? 'Deposit failed');
    }
    return mapTransactionResponseToEntity(response.data!);
  }

  @override
  Future<WalletTransaction> withdraw(double amount, String? description) async {
    final token = await _getToken();
    final request = AmountRequestModel(
      amount: amount,
      description: description,
    );
    final response = await _datasource.withdraw(request, token);
    if (!response.success || response.data == null) {
      throw Exception(response.error?.message ?? 'Withdrawal failed');
    }
    return mapTransactionResponseToEntity(response.data!);
  }

  @override
  Future<List<WalletTransaction>> transfer(
    String toWalletId,
    double amount,
    String? description,
  ) async {
    final token = await _getToken();
    final request = TransferRequestModel(
      toWalletId: toWalletId,
      amount: amount,
      description: description,
    );
    final response = await _datasource.transfer(request, token);
    if (!response.success || response.data == null) {
      throw Exception(response.error?.message ?? 'Transfer failed');
    }
    return response.data!.map(mapTransactionResponseToEntity).toList();
  }

  @override
  Future<List<WalletTransaction>> getMyTransactions() async {
    final token = await _getToken();
    final response = await _datasource.getMyTransactions(token);
    if (!response.success || response.data == null) {
      throw Exception(
        response.error?.message ?? 'Failed to fetch transactions',
      );
    }
    return response.data!.map(mapTransactionResponseToEntity).toList();
  }

  @override
  Future<List<WalletTransaction>> getMyTransactionsByDate(DateTime date) async {
    final token = await _getToken();
    final response = await _datasource.getMyTransactionsByDate(date, token);
    if (!response.success || response.data == null) {
      throw Exception(
        response.error?.message ?? 'Failed to fetch transactions',
      );
    }
    return response.data!.map(mapTransactionResponseToEntity).toList();
  }
}
