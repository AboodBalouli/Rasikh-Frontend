import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/ai_chat_message.dart';
import '../../domain/usecases/send_ai_chat_message_usecase.dart';
import 'ai_chat_state.dart';

class AiChatController extends StateNotifier<AiChatState> {
  final SendAiChatMessageUseCase _sendUseCase;
  final Uuid _uuid;

  AiChatController({required SendAiChatMessageUseCase sendUseCase, Uuid? uuid})
    : _sendUseCase = sendUseCase,
      _uuid = uuid ?? const Uuid(),
      super(AiChatState.initial(sessionId: (uuid ?? const Uuid()).v4()));

  Future<void> sendUserMessage(String text) async {
    final prompt = text.trim();
    if (prompt.isEmpty) return;

    final userMessage = AiChatMessage(
      id: _uuid.v4(),
      role: AiChatRole.user,
      content: prompt,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [userMessage, ...state.messages],
      isSending: true,
      error: null,
    );

    try {
      final result = await _sendUseCase(
        sessionId: state.sessionId,
        prompt: prompt,
      );
      state = state.copyWith(
        messages: [result.assistantMessage, ...state.messages],
        isSending: false,
        error: null,
        lastRoute: result.route,
        lastRecommendProducts: result.recommendProducts,
        lastSources: result.sources,
      );
    } catch (e) {
      state = state.copyWith(isSending: false, error: e);
    }
  }
}
