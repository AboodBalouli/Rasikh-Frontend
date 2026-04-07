/// DTO for wallet response from the backend.
class WalletResponseModel {
  final int id;
  final String walletId;
  final double balance;

  const WalletResponseModel({
    required this.id,
    required this.walletId,
    required this.balance,
  });

  factory WalletResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletResponseModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      walletId: (json['walletId'] as String?) ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
