import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/core/constants/custom_button.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/providers/locale_provider.dart';
import 'dart:ui';

class PasswordSettingsSection extends ConsumerStatefulWidget {
  const PasswordSettingsSection({super.key});

  @override
  ConsumerState<PasswordSettingsSection> createState() =>
      _PasswordSettingsSectionState();
}

class _PasswordSettingsSectionState
    extends ConsumerState<PasswordSettingsSection> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    setState(() {
      _hasError = false;
      _errorMessage = '';

      final newPassword = _newPasswordController.text;
      final confirmPassword = _confirmPasswordController.text;

      if (newPassword != confirmPassword) {
        _hasError = true;
        _errorMessage = AppStrings.passwordsDoNotMatch;
        return;
      }

      if (newPassword.length < 8) {
        _hasError = true;
        _errorMessage = AppStrings.passwordMustBe8Chars;
        return;
      }

      final invalidChars = RegExp(r'[*&^#!%\-$]');
      if (invalidChars.hasMatch(newPassword)) {
        _hasError = true;
        _errorMessage = AppStrings.passwordContainsInvalidChars;
        return;
      }
    });

    if (_hasError) {
      _vibrateError();
    }
  }

  void _vibrateError() {
    HapticFeedback.heavyImpact();
  }

  void _handleSave() {
    _validatePassword();
    if (!_hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.passwordChangedSuccessfully)),
      );
      _resetForm();
    }
  }

  void _resetForm() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch locale to trigger rebuild
    ref.watch(localeProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPasswordField(
            label: AppStrings.currentPassword,
            controller: _currentPasswordController,
            showPassword: _showCurrentPassword,
            onToggle: () {
              setState(() => _showCurrentPassword = !_showCurrentPassword);
            },
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            label: AppStrings.newPassword,
            controller: _newPasswordController,
            showPassword: _showNewPassword,
            onToggle: () {
              setState(() => _showNewPassword = !_showNewPassword);
            },
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            label: AppStrings.confirmNewPassword,
            controller: _confirmPasswordController,
            showPassword: _showConfirmPassword,
            onToggle: () {
              setState(() => _showConfirmPassword = !_showConfirmPassword);
            },
          ),
          if (_hasError)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: AppStrings.cancel,
                  onPressed: _resetForm,
                  backgroundColor: Colors.grey[300],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: AppStrings.save,
                  onPressed: _handleSave,
                  backgroundColor: TColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool showPassword,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: TColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: TextField(
              controller: controller,
              obscureText: !showPassword,
              onChanged: (_) => _validatePassword(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.65),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _hasError
                        ? Colors.red.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _hasError
                        ? Colors.red.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: TColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                hintText: label,
                suffixIcon: GestureDetector(
                  onTap: onToggle,
                  child: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: TColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
