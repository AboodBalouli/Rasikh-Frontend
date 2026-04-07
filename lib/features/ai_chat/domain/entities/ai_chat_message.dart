enum AiChatRole { user, assistant }

class AiChatMessage {
  final String id;
  final AiChatRole role;
  final String content;
  final DateTime createdAt;

  const AiChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });
}
