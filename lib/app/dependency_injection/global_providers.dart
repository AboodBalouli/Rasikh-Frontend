import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wrap the app with any global providers needed.
/// Since we're using Riverpod's ProviderScope in main.dart,
/// this is now a simple pass-through wrapper.
Widget wrapWithGlobalProviders({required Widget child}) {
  // All Riverpod providers are handled by ProviderScope in main.dart
  // This wrapper is kept for backwards compatibility and potential future use
  return child;
}
