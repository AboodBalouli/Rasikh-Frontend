import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/auth_app_bar.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/gradient_background.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter_application_1/features/auth/values/app_strings.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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

                SizedBox(height: context.hp(6)), // Responsive spacing
                Text(
                  AppStrings.signInToYourAccount,
                  style: AppTheme.bodySmall.copyWith(
                    fontSize: context.sp(14), // Scalable font
                  ),
                ),
                LoginForm(),
              ],
            ),
          ),

          const Positioned(top: 0, left: 0, right: 0, child: AuthAppBar()),
        ],
      ),
    );
  }
}
