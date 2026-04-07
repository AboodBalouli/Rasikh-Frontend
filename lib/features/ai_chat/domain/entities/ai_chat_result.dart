import 'ai_chat_message.dart';
import 'ai_chat_route.dart';
import 'recommend_product.dart';
import 'source_item.dart';

class AiChatResult {
  final AiChatMessage assistantMessage;
  final AiChatRoute route;
  final List<RecommendProduct> recommendProducts;
  final List<SourceItem> sources;

  const AiChatResult({
    required this.assistantMessage,
    required this.route,
    required this.recommendProducts,
    required this.sources,
  });
}
