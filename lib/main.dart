import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app.dart';
import 'package:flutter_application_1/app/dependency_injection/global_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(wrapWithGlobalProviders(child: const ProviderScope(child: MyApp())));
}
