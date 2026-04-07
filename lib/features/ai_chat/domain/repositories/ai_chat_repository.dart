import '../entities/ai_chat_result.dart';

abstract class AiChatRepository {
  Future<AiChatResult> sendMessage({
    required String sessionId,
    required String prompt,
  });
}
