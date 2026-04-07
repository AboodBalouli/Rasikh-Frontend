import 'package:flutter_application_1/app/dependency_injection/riverpod_providers.dart';
import 'package:flutter_application_1/core/constants/app_config.dart';
import 'package:flutter_application_1/core/network/api_service.dart';
import 'package:flutter_application_1/core/network/token_provider.dart';
import 'package:flutter_application_1/features/ai_chat/data/datasources/ai_chat_remote_datasource.dart';
import 'package:flutter_application_1/features/ai_chat/data/repositories/ai_chat_repository_impl.dart';
import 'package:flutter_application_1/features/ai_chat/domain/repositories/ai_chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aiChatApiServiceProvider = Provider<ApiService>((ref) {
  final client = ref.watch(httpClientProvider);
  return ApiService(client: client, baseUrl: AppConfig.chatbotBaseUrl);
});

final aiChatTokenProvider = Provider<TokenProvider>((ref) {
  return ref.watch(tokenProvider);
});

final aiChatRemoteDatasourceProvider = Provider<AiChatRemoteDatasource>((ref) {
  final api = ref.watch(aiChatApiServiceProvider);
  return AiChatRemoteDatasource(api: api);
});

final aiChatRepositoryProvider = Provider<AiChatRepository>((ref) {
  final remote = ref.watch(aiChatRemoteDatasourceProvider);
  final token = ref.watch(aiChatTokenProvider);
  return AiChatRepositoryImpl(remote: remote, tokenProvider: token);
});
