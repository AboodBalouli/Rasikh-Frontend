import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class AppConfig {
  const AppConfig._();

  /// Override at build/run time:
  /// `flutter run --dart-define=API_BASE_URL=http://<ip>:8080`
  static const String _envApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// Override only the chatbot service base URL at build/run time:
  /// `flutter run --dart-define=CHATBOT_BASE_URL=http://<ip>:8000`
  static const String _envChatbotBaseUrl = String.fromEnvironment(
    'CHATBOT_BASE_URL',
    defaultValue: '',
  );

  /// Best-effort default for local development.
  ///
  /// Note: On Android emulator, `localhost` points to the emulator itself.
  /// Use `10.0.2.2` to reach the host machine.
  static String get apiBaseUrl {
    if (_envApiBaseUrl.isNotEmpty) return _envApiBaseUrl;
    if (kIsWeb) return 'http://localhost:8080';
    if (Platform.isAndroid) return 'http://10.0.2.2:8080';
    return 'http://localhost:8080';

    // if (kIsWeb) return 'http://184.174.37.91:08080';
    // if (Platform.isAndroid) return 'http://184.174.37.91:08080';
    // return 'http://184.174.37.91:08080';
  }

  /// Base URL used by the AI chatbot feature.
  ///
  /// Defaults to [apiBaseUrl] (same backend). Override with [CHATBOT_BASE_URL]
  /// if the chatbot runs as a separate service (e.g. on port 8000).
  static String get chatbotBaseUrl {
    if (_envChatbotBaseUrl.isNotEmpty) return _envChatbotBaseUrl;
    return apiBaseUrl;
  }
}
