/// DTO for transaction response from the backend.
class TransactionResponseModel {
  final int id;
  final String? walletId;
  final String type; // DEPOSIT, WITHDRAWAL, TRANSFER
  final DateTime? date;
  final String? time;
  final double amount;
  final String? description;
  final String? receiver;

  const TransactionResponseModel({
    required this.id,
    this.walletId,
    required this.type,
    this.date,
    this.time,
    required this.amount,
    this.description,
    this.receiver,
  });

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionResponseModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      walletId: json['walletId'] as String?,
      type: (json['type'] as String?) ?? 'UNKNOWN',
      date: _parseDate(json['date']),
      time: json['time'] as String?,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String?,
      receiver: json['receiver'] as String?,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      // Handle LocalDate format: YYYY-MM-DD
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
