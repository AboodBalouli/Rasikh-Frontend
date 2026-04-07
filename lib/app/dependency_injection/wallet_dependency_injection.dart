import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:flutter_application_1/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:flutter_application_1/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:http/http.dart' as http;

/// HTTP client provider for wallet.
final walletHttpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

/// Remote datasource provider for wallet.
final walletRemoteDatasourceProvider = Provider<WalletRemoteDatasource>((ref) {
  final client = ref.watch(walletHttpClientProvider);
  return WalletRemoteDatasource(client: client);
});

/// Repository provider for wallet.
final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final datasource = ref.watch(walletRemoteDatasourceProvider);
  return WalletRepositoryImpl(datasource: datasource);
});
