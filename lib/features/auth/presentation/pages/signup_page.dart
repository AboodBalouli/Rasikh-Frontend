import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/controllers/register_controller_provider.dart';
import 'package:flutter_application_1/features/auth/presentation/controllers/register_controller.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/auth_app_bar.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/register_form.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/gradient_background.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final RegisterController _controller;

  @override
  void initState() {
    super.initState();

    _controller = RegisterControllerFactory.create();
  }

  @override
  void dispose() {
    _controller.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                GradientBackground(
                  children: [
                    SizedBox(
                      height: context.hp(12),
                    ), // Responsive: ~12% of screen height
                  ],
                ),
                SizedBox(height: context.hp(2.5)), // Responsive spacing
                Center(
                  child: Text(
                    'انشاء حساب',
                    style: AppTheme.bodySmall.copyWith(
                      fontSize: context.sp(14), // Scalable font
                    ),
                  ),
                ),
                SizedBox(height: context.hp(2.5)), // Responsive spacing
                Padding(
                  padding: Responsive.paddingH(context),
                  child: RegisterForm(controller: _controller),
                ),
              ],
            ),
          ),
          const Positioned(top: 0, left: 0, right: 0, child: AuthAppBar()),
        ],
      ),
    );
  }
}
