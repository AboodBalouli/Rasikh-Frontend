import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/providers/locale_provider.dart';
import 'dart:ui';

class LanguageSettingsSection extends ConsumerWidget {
  const LanguageSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeState = ref.watch(localeProvider);
    final selectedLanguage = localeState.locale.languageCode;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.chooseLanguage,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: TColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          _buildLanguageOption(
            context: context,
            ref: ref,
            code: 'ar',
            name: 'العربية',
            flag: '🇸🇦',
            isSelected: selectedLanguage == 'ar',
          ),
          const SizedBox(height: 12),
          _buildLanguageOption(
            context: context,
            ref: ref,
            code: 'en',
            name: 'English',
            flag: '🇬🇧',
            isSelected: selectedLanguage == 'en',
          ),
          const SizedBox(height: 32),
          Text(
            AppStrings.languageAppliedImmediately,
            style: TextStyle(fontSize: 14, color: TColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required WidgetRef ref,
    required String code,
    required String name,
    required String flag,
    required bool isSelected,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: GestureDetector(
          onTap: () async {
            await ref.read(localeProvider.notifier).setLocale(code);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    code == 'ar'
                        ? AppStrings.languageChangedToArabic
                        : AppStrings.languageChangedToEnglish,
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? TColors.primary.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? TColors.primary
                    : Colors.white.withValues(alpha: 0.25),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? TColors.primary.withValues(alpha: 0.15)
                      : TColors.primary.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(flag, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: TColors.textPrimary,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: TColors.primary, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
