/// Request model for deposit/withdraw operations.
class AmountRequestModel {
  final double amount;
  final String? description;

  const AmountRequestModel({required this.amount, this.description});

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      if (description != null) 'description': description,
    };
  }
}
