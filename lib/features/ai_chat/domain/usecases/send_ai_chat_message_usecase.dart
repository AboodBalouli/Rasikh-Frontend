import '../repositories/ai_chat_repository.dart';
import '../entities/ai_chat_result.dart';

class SendAiChatMessageUseCase {
  final AiChatRepository _repository;

  const SendAiChatMessageUseCase(this._repository);

  Future<AiChatResult> call({
    required String sessionId,
    required String prompt,
  }) {
    return _repository.sendMessage(sessionId: sessionId, prompt: prompt);
  }
}
