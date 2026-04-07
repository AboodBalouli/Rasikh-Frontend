import 'package:flutter_application_1/core/network/api_service.dart';

import '../models/ai_chat_request.dart';
import '../models/ai_chat_response.dart';

class AiChatRemoteDatasource {
  final ApiService _api;
  final String _chatPath;

  AiChatRemoteDatasource({
    required ApiService api,
    String chatPath = '/api/ai/chatbot/chat',
  }) : _api = api,
       _chatPath = chatPath;

  Future<AiChatResponse> sendPrompt({
    required AiChatRequest request,
    String? token,
  }) async {
    final json = await _api.post(_chatPath, request.toJson(), token: token);
    return AiChatResponse.fromApi(json);
  }
}
