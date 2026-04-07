import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/utils/authentication_regex.dart';
import 'package:flutter_application_1/features/auth/presentation/controllers/register_controller.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/app_text_form_field.dart';
import 'package:flutter_application_1/features/auth/values/app_strings.dart';
import 'package:go_router/go_router.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({required this.controller, super.key});

  final RegisterController controller;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextFormField(
            textInputAction: TextInputAction.next,
            labelText: "الاسم الاول",
            keyboardType: TextInputType.name,
            controller: widget.controller.firstNameController,
            textColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              return value!.isEmpty ? "يرجى إدخال الاسم الاول" : null;
            },
          ),
          const SizedBox(height: 15),
          AppTextFormField(
            textInputAction: TextInputAction.next,
            labelText: "الاسم الاخير",
            keyboardType: TextInputType.name,
            controller: widget.controller.lastNameController,
            textColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              return value!.isEmpty ? "يرجى إدخال الاسم الاخير" : null;
            },
          ),
          const SizedBox(height: 15),
          AppTextFormField(
            textInputAction: TextInputAction.next,
            labelText: "البريد الإلكتروني",
            keyboardType: TextInputType.emailAddress,
            controller: widget.controller.emailController,
            textColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "يرجى إدخال بريدك الإلكتروني";
              }
              final hasAt = value.contains('@');
              final hasDotCom = value.toLowerCase().contains('.com');
              if (!hasAt || !hasDotCom) {
                return "يرجى إدخال بريد إلكتروني صالح";
              }
              return AuthenticationRegex.emailRegex.hasMatch(value)
                  ? null
                  : "يرجى إدخال بريد إلكتروني صالح";
            },
          ),
          const SizedBox(height: 15),
          ValueListenableBuilder(
            valueListenable: widget.controller.passwordNotifier,
            builder: (_, passwordObscure, _) {
              return AppTextFormField(
                textInputAction: TextInputAction.next,
                labelText: "كلمة المرور",
                keyboardType: TextInputType.visiblePassword,
                controller: widget.controller.passwordController,
                textColor: Colors.grey,
                obscureText: passwordObscure,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "يرجى إدخال كلمة المرور";
                  }
                  if (value.length < 8) {
                    return 'لا يجب ان تقل كلمة المرور عن 5';
                  }
                  if (value.contains('*') ||
                      value.contains('&') ||
                      value.contains('#') ||
                      value.contains('-') ||
                      value.contains('%') ||
                      value.contains('^') ||
                      value.contains(',')) {
                    return 'الرموز غير مسموحة (- * % ^ # ,)';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: () => widget.controller.passwordNotifier.value =
                      !passwordObscure,
                  style: IconButton.styleFrom(
                    minimumSize: const Size.square(48),
                  ),
                  icon: Icon(
                    passwordObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder(
            valueListenable: widget.controller.passwordNotifier,
            builder: (_, passwordObscure, _) {
              return AppTextFormField(
                textInputAction: TextInputAction.next,
                labelText: "تأكيد كلمة المرور",
                keyboardType: TextInputType.visiblePassword,
                controller: widget.controller.confirmPasswordController,
                textColor: Colors.grey,
                obscureText: passwordObscure,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "يرجى إدخال كلمة المرور";
                  }
                  if (value != widget.controller.passwordController.text) {
                    return 'كلمة المرور غير متطابقة';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: () => widget.controller.passwordNotifier.value =
                      !passwordObscure,
                  style: IconButton.styleFrom(
                    minimumSize: const Size.square(48),
                  ),
                  icon: Icon(
                    passwordObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder(
            valueListenable: widget.controller.fieldValidNotifier,
            builder: (_, isValid, _) {
              return SizedBox(
                width: double.infinity,
                height: 40,
                child: ValueListenableBuilder<bool>(
                  valueListenable: widget.controller.isLoading,
                  builder: (_, loading, __) {
                    return FilledButton(
                      onPressed: () async {
                        final valid =
                            _formKey.currentState?.validate() ?? false;
                        if (!valid) {
                          HapticFeedback.mediumImpact();
                          return;
                        }
                        _formKey.currentState?.save();
                        await widget.controller.register(context);
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
                          : const Text(AppStrings.SignUp),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              context.push('/login');
            },
            style: TextButton.styleFrom(backgroundColor: Colors.transparent),
            child: const Text(
              'هل لديك حساب بالفعل ؟',
              style: TextStyle(
                color: Color.fromARGB(255, 83, 148, 93),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
