import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/app_elevated_button.dart';
import 'package:go_router/go_router.dart';

class AuthActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppElevatedButton(
          onPressed: () {
            context.push('/login');
          },
          text: "تسجيل الدخول",
        ),

        const SizedBox(height: 10),

        AppElevatedButton(
          onPressed: () {
            context.push('/register');
          },
          text: "انشاء حساب",
        ),

        const SizedBox(height: 10),

       TextButton(
          onPressed: () {
            context.go('/home');
          },
          child: const Text("المتابعة كضيف" , style: TextStyle(color: Colors.grey),
        ),
       ),
        const SizedBox(height: 10),
      ],
    );
  }
}
