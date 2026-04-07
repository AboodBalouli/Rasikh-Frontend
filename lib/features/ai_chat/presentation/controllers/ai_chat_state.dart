import '../../domain/entities/ai_chat_message.dart';
import '../../domain/entities/ai_chat_route.dart';
import '../../domain/entities/recommend_product.dart';
import '../../domain/entities/source_item.dart';

class AiChatState {
  final String sessionId;
  final List<AiChatMessage> messages;
  final bool isSending;
  final Object? error;
  final AiChatRoute lastRoute;
  final List<RecommendProduct> lastRecommendProducts;
  final List<SourceItem> lastSources;

  const AiChatState({
    required this.sessionId,
    required this.messages,
    required this.isSending,
    required this.error,
    required this.lastRoute,
    required this.lastRecommendProducts,
    required this.lastSources,
  });

  const AiChatState.initial({required this.sessionId})
    : messages = const [],
      isSending = false,
      error = null,
      lastRoute = AiChatRoute.unknown,
      lastRecommendProducts = const [],
      lastSources = const [];

  AiChatState copyWith({
    String? sessionId,
    List<AiChatMessage>? messages,
    bool? isSending,
    Object? error,
    AiChatRoute? lastRoute,
    List<RecommendProduct>? lastRecommendProducts,
    List<SourceItem>? lastSources,
  }) {
    return AiChatState(
      sessionId: sessionId ?? this.sessionId,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      error: error,
      lastRoute: lastRoute ?? this.lastRoute,
      lastRecommendProducts:
          lastRecommendProducts ?? this.lastRecommendProducts,
      lastSources: lastSources ?? this.lastSources,
    );
  }
}
