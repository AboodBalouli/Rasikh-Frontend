class AiChatRequest {
  final String sessionId;
  final String message;

  const AiChatRequest({required this.sessionId, required this.message});

  Map<String, dynamic> toJson() {
    return {'session_id': sessionId, 'message': message};
  }
}
