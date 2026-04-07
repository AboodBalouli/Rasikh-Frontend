// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_1/app/app.dart';
import 'package:flutter_application_1/app/dependency_injection/global_providers.dart';

void main() {
  testWidgets('App builds (smoke test)', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrapWithGlobalProviders(child: const ProviderScope(child: MyApp())),
    );
    await tester.pumpAndSettle();

    // If we reached here without exceptions, the app bootstrapped.
    expect(find.byType(MyApp), findsOneWidget);
  });
}
