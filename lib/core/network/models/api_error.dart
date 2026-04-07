class ApiError {
  final String timestamp;
  final int status;
  final String error;
  final String message;
  final String path;
  final List<ValidationError> errors;

  ApiError({
    required this.timestamp,
    required this.status,
    required this.error,
    required this.message,
    required this.path,
    required this.errors,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      timestamp: json['timestamp'] ?? '',
      status: json['status'] ?? 0,
      error: json['error'] ?? '',
      message: json['message'] ?? '',
      path: json['path'] ?? '',
      errors: (json['errors'] as List<dynamic>? ?? [])
          .map((e) => ValidationError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ValidationError {
  final String field;
  final String message;
  final dynamic rejectedValue;

  ValidationError({
    required this.field,
    required this.message,
    required this.rejectedValue,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) {
    return ValidationError(
      field: json['field'] ?? '',
      message: json['message'] ?? '',
      rejectedValue: json['rejectedValue'],
    );
  }
}
