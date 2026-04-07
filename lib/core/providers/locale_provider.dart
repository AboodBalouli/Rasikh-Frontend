import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';

/// Locale state containing current locale and text direction
class LocaleState {
  final Locale locale;
  final TextDirection textDirection;

  const LocaleState({required this.locale, required this.textDirection});

  bool get isArabic => locale.languageCode == 'ar';
  bool get isEnglish => locale.languageCode == 'en';

  LocaleState copyWith({Locale? locale, TextDirection? textDirection}) {
    return LocaleState(
      locale: locale ?? this.locale,
      textDirection: textDirection ?? this.textDirection,
    );
  }

  static const LocaleState arabic = LocaleState(
    locale: Locale('ar'),
    textDirection: TextDirection.rtl,
  );

  static const LocaleState english = LocaleState(
    locale: Locale('en'),
    textDirection: TextDirection.ltr,
  );
}

/// Manages app locale with persistence using Riverpod Notifier
class LocaleNotifier extends Notifier<LocaleState> {
  static const _languageKey = 'language_code';

  @override
  LocaleState build() {
    _loadSavedLocale();
    return LocaleState.arabic;
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);

      if (languageCode == 'en') {
        state = LocaleState.english;
        AppStrings.languageCode = 'en';
      } else {
        state = LocaleState.arabic;
        AppStrings.languageCode = 'ar';
      }
    } catch (e) {
      // Default to Arabic on error
      state = LocaleState.arabic;
      AppStrings.languageCode = 'ar';
    }
  }

  Future<void> setArabic() async {
    state = LocaleState.arabic;
    AppStrings.languageCode = 'ar';
    await _saveLocale('ar');
  }

  Future<void> setEnglish() async {
    state = LocaleState.english;
    AppStrings.languageCode = 'en';
    await _saveLocale('en');
  }

  Future<void> toggleLocale() async {
    if (state.isArabic) {
      await setEnglish();
    } else {
      await setArabic();
    }
  }

  Future<void> setLocale(String languageCode) async {
    if (languageCode == 'en') {
      await setEnglish();
    } else {
      await setArabic();
    }
  }

  Future<void> _saveLocale(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      // Silently fail - locale change still works for current session
    }
  }
}

/// Global locale provider
final localeProvider = NotifierProvider<LocaleNotifier, LocaleState>(() {
  return LocaleNotifier();
});

/// Convenience providers for common use cases
final isArabicProvider = Provider<bool>((ref) {
  return ref.watch(localeProvider).isArabic;
});

final isEnglishProvider = Provider<bool>((ref) {
  return ref.watch(localeProvider).isEnglish;
});

final textDirectionProvider = Provider<TextDirection>((ref) {
  return ref.watch(localeProvider).textDirection;
});

final currentLocaleProvider = Provider<Locale>((ref) {
  return ref.watch(localeProvider).locale;
});
