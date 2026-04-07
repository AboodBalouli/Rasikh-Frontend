import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_1/core/utils/authentication_regex.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/providers/locale_provider.dart';
import 'package:flutter_application_1/features/auth/presentation/controllers/login_controller_provider.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/app_text_form_field.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(loginControllerProvider.notifier);
    final state = ref.watch(loginControllerProvider);
    // Watch locale to rebuild when language changes
    ref.watch(localeProvider);

    return Container(
      padding: Responsive.paddingH(
        context,
      ).copyWith(top: context.hp(2), bottom: context.hp(2)),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextFormField(
              controller: controller.emailController,
              labelText: AppStrings.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.pleaseEnterEmailAddress;
                }
                final hasAt = value.contains('@');
                final hasDotCom = value.toLowerCase().contains('.com');
                if (!hasAt || !hasDotCom) {
                  return AppStrings.invalidEmailAddress;
                }
                return AuthenticationRegex.emailRegex.hasMatch(value)
                    ? null
                    : AppStrings.invalidEmailAddress;
              },
            ),
            const SizedBox(height: 15),
            AppTextFormField(
              obscureText: state.isPasswordObscured,
              controller: controller.passwordController,
              labelText: AppStrings.password,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.pleaseEnterPassword;
                }
                if (value.length < 5) {
                  return AppStrings.passwordMustBe5Chars;
                }
                if (value.contains('*') ||
                    value.contains('&') ||
                    value.contains('#') ||
                    value.contains('-') ||
                    value.contains('%') ||
                    value.contains('^') ||
                    value.contains(',')) {
                  return AppStrings.specialCharsNotAllowed;
                }
                return null;
              },
              suffixIcon: IconButton(
                onPressed: controller.togglePasswordVisibility,
                style: IconButton.styleFrom(minimumSize: const Size.square(48)),
                icon: Icon(
                  state.isPasswordObscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                context.push('/forgot-password');
              },
              child: Text(AppStrings.forgotPassword),
            ),

            const SizedBox(height: 20),
            Builder(
              builder: (_) {
                final loading = state.isLoading;

                return SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: FilledButton(
                    onPressed: () async {
                      final valid = _formKey.currentState?.validate() ?? false;
                      if (!valid) {
                        HapticFeedback.mediumImpact();
                        return;
                      }
                      _formKey.currentState?.save();
                      await controller.login(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 83, 148, 93),
                    ),
                    child: loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(AppStrings.login),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  context.push('/register');
                },
                child: Text(
                  AppStrings.dontHaveAccount,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 83, 148, 93),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
