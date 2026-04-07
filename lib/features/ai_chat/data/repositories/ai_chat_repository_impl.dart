import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/ai_chat_exception.dart';
import '../../domain/entities/ai_chat_message.dart';
import '../../domain/entities/ai_chat_result.dart';
import '../../domain/entities/ai_chat_route.dart';
import '../../domain/entities/recommend_product.dart';
import '../../domain/entities/source_item.dart';
import '../../domain/repositories/ai_chat_repository.dart';
import '../datasources/ai_chat_remote_datasource.dart';
import '../models/ai_chat_request.dart';

class AiChatRepositoryImpl implements AiChatRepository {
  final AiChatRemoteDatasource _remote;
  final TokenProvider _tokenProvider;
  final Uuid _uuid;

  AiChatRepositoryImpl({
    required AiChatRemoteDatasource remote,
    required TokenProvider tokenProvider,
    Uuid? uuid,
  }) : _remote = remote,
       _tokenProvider = tokenProvider,
       _uuid = uuid ?? const Uuid();

  @override
  Future<AiChatResult> sendMessage({
    required String sessionId,
    required String prompt,
  }) async {
    try {
      final token = await _tokenProvider.getToken();
      final response = await _remote.sendPrompt(
        request: AiChatRequest(sessionId: sessionId, message: prompt),
        token: token,
      );

      final answer = response.answer.trim();
      if (answer.isEmpty) {
        throw const AiChatException('Empty AI response');
      }

      final assistantMessage = AiChatMessage(
        id: _uuid.v4(),
        role: AiChatRole.assistant,
        content: answer,
        createdAt: DateTime.now(),
      );

      final recommendProducts = response.recommendProducts
          .map((p) {
            final id = p['id'];
            final name = p['name'];
            return RecommendProduct(
              id: id is int ? id : int.tryParse(id?.toString() ?? '') ?? 0,
              name: name?.toString() ?? '',
              price: p['price'] as num?,
              rating: p['rating'] as num?,
              score: p['score'] as num?,
            );
          })
          .where((p) => p.id != 0 && p.name.trim().isNotEmpty)
          .toList();

      final sources = response.sources
          .map((s) {
            return SourceItem(
              title: (s['title'] ?? '').toString(),
              snippet: (s['snippet'] ?? '').toString(),
              url: (s['url'] ?? '').toString(),
            );
          })
          .where((s) => s.title.trim().isNotEmpty || s.url.trim().isNotEmpty)
          .toList();

      return AiChatResult(
        assistantMessage: assistantMessage,
        route: aiChatRouteFromApi(response.route),
        recommendProducts: recommendProducts,
        sources: sources,
      );
    } catch (e) {
      if (e is AiChatException) rethrow;
      throw const AiChatException('Failed to send message');
    }
  }
}
