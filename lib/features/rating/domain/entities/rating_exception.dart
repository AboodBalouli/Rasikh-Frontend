/// Exception thrown when a rating operation fails.
class RatingException implements Exception {
  final String message;

  const RatingException(this.message);

  @override
  String toString() => 'RatingException: $message';
}
