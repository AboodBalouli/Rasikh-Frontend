class AiChatException implements Exception {
  final String message;

  const AiChatException(this.message);

  @override
  String toString() => 'AiChatException: $message';
}
