export 'package:flutter_application_1/app/dependency_injection/ai_chat_dependency_injection.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_application_1/app/dependency_injection/ai_chat_dependency_injection.dart';

import '../../domain/usecases/send_ai_chat_message_usecase.dart';
import '../controllers/ai_chat_controller.dart';
import '../controllers/ai_chat_state.dart';

final sendAiChatMessageUseCaseProvider = Provider<SendAiChatMessageUseCase>((
  ref,
) {
  final repo = ref.watch(aiChatRepositoryProvider);
  return SendAiChatMessageUseCase(repo);
});

final aiChatControllerProvider =
    StateNotifierProvider<AiChatController, AiChatState>((ref) {
      final useCase = ref.watch(sendAiChatMessageUseCaseProvider);
      return AiChatController(sendUseCase: useCase);
    });
