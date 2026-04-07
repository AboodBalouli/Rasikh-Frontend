import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_1/app/router.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/core/utils/helpers/snackbar_helper.dart';
import 'package:flutter_application_1/core/providers/locale_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeState = ref.watch(localeProvider);

    return Directionality(
      textDirection: localeState.textDirection,
      child: MaterialApp.router(
        scaffoldMessengerKey: SnackbarHelper.key,
        title: 'Rasikh',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        routerConfig: appRouter,
        locale: localeState.locale,
        supportedLocales: const [
          Locale('ar'), // Arabic
          Locale('en'), // English
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
