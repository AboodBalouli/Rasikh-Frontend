import 'dart:convert';

import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/network/models/api_response.dart';
import 'package:flutter_application_1/features/wallet/data/models/amount_request_model.dart';
import 'package:flutter_application_1/features/wallet/data/models/transaction_response_model.dart';
import 'package:flutter_application_1/features/wallet/data/models/transfer_request_model.dart';
import 'package:flutter_application_1/features/wallet/data/models/wallet_response_model.dart';
import 'package:http/http.dart' as http;

/// Remote datasource for wallet and transaction API.
class WalletRemoteDatasource {
  final http.Client client;

  WalletRemoteDatasource({required this.client});

  static Uri _apiUri(String path) {
    return Uri.parse('${AppConfig.apiBaseUrl}$path');
  }

  /// GET `/wallet?walletId={id}` - Get wallet by ID.
  Future<ApiResponse<WalletResponseModel>> getWallet(
    String walletId,
    String token,
  ) async {
    final url = _apiUri(
      '/wallet',
    ).replace(queryParameters: {'walletId': walletId});
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<WalletResponseModel>.fromJson(decoded, (json) {
      return WalletResponseModel.fromJson(json as Map<String, dynamic>);
    });
  }

  /// GET `/wallet/balance?walletId={id}` - Get wallet balance.
  Future<ApiResponse<double>> getWalletBalance(
    String walletId,
    String token,
  ) async {
    final url = _apiUri(
      '/wallet/balance',
    ).replace(queryParameters: {'walletId': walletId});
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<double>.fromJson(decoded, (json) {
      if (json is num) return json.toDouble();
      return 0.0;
    });
  }

  /// POST `/transaction/me/deposit` - Deposit to my wallet.
  Future<ApiResponse<TransactionResponseModel>> deposit(
    AmountRequestModel request,
    String token,
  ) async {
    final url = _apiUri('/transaction/me/deposit');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<TransactionResponseModel>.fromJson(decoded, (json) {
      return TransactionResponseModel.fromJson(json as Map<String, dynamic>);
    });
  }

  /// POST `/transaction/me/withdraw` - Withdraw from my wallet.
  Future<ApiResponse<TransactionResponseModel>> withdraw(
    AmountRequestModel request,
    String token,
  ) async {
    final url = _apiUri('/transaction/me/withdraw');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<TransactionResponseModel>.fromJson(decoded, (json) {
      return TransactionResponseModel.fromJson(json as Map<String, dynamic>);
    });
  }

  /// POST `/transaction/me/transfer` - Transfer to another wallet.
  Future<ApiResponse<List<TransactionResponseModel>>> transfer(
    TransferRequestModel request,
    String token,
  ) async {
    final url = _apiUri('/transaction/me/transfer');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<List<TransactionResponseModel>>.fromJson(decoded, (
      json,
    ) {
      if (json is List) {
        return json
            .map(
              (item) => TransactionResponseModel.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();
      }
      return [];
    });
  }

  /// GET `/transaction/me` - Get my transactions.
  Future<ApiResponse<List<TransactionResponseModel>>> getMyTransactions(
    String token,
  ) async {
    final url = _apiUri('/transaction/me');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<List<TransactionResponseModel>>.fromJson(decoded, (
      json,
    ) {
      if (json is List) {
        return json
            .map(
              (item) => TransactionResponseModel.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();
      }
      return [];
    });
  }

  /// GET `/transaction/me/by-date?date={date}` - Get transactions by date.
  Future<ApiResponse<List<TransactionResponseModel>>> getMyTransactionsByDate(
    DateTime date,
    String token,
  ) async {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final url = _apiUri(
      '/transaction/me/by-date',
    ).replace(queryParameters: {'date': dateStr});
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON object response');
    }

    return ApiResponse<List<TransactionResponseModel>>.fromJson(decoded, (
      json,
    ) {
      if (json is List) {
        return json
            .map(
              (item) => TransactionResponseModel.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();
      }
      return [];
    });
  }
}
