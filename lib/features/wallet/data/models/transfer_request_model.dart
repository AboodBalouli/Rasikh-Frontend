/// Request model for transfer operation.
class TransferRequestModel {
  final String toWalletId;
  final double amount;
  final String? description;

  const TransferRequestModel({
    required this.toWalletId,
    required this.amount,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'toWalletId': toWalletId,
      'amount': amount,
      if (description != null) 'description': description,
    };
  }
}
