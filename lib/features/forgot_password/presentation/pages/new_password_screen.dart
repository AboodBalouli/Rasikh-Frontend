import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import '../controllers/forgot_password_controller.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  bool _isConfirmObscured = true;

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgotState = ref.watch(forgotPasswordProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: context.sp(20),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: context.wp(6)),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: context.hp(2)),
                Container(
                  padding: EdgeInsets.all(context.wp(5)),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      99,
                      147,
                      109,
                    ).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.security_rounded,
                    size: context.sp(60),
                    color: const Color.fromARGB(255, 83, 148, 93),
                  ),
                ),
                SizedBox(height: context.hp(4)),
                Text(
                  "كلمة سر جديدة",
                  style: TextStyle(
                    fontSize: context.sp(23),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: context.hp(1.5)),
                Text(
                  "يرجى كتابة كلمة سر قوية وسهلة التذكر في نفس الوقت",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.sp(15),
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: context.hp(5)),

                _buildPasswordField(
                  controller: _passwordController,
                  label: "كلمة السر الجديدة",
                  isObscured: _isObscured,
                  onToggle: () => setState(() => _isObscured = !_isObscured),
                  context: context,
                ),

                SizedBox(height: context.hp(2.5)),

                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: "تأكيد كلمة السر",
                  isObscured: _isConfirmObscured,
                  onToggle: () =>
                      setState(() => _isConfirmObscured = !_isConfirmObscured),
                  context: context,
                ),

                SizedBox(height: context.hp(5)),

                SizedBox(
                  width: double.infinity,
                  height: context.hp(7),
                  child: ElevatedButton(
                    onPressed: forgotState.isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 83, 148, 93),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: forgotState.isLoading
                        ? SizedBox(
                            height: context.sp(20),
                            width: context.sp(20),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "تحديث ودخول",
                            style: TextStyle(
                              fontSize: context.sp(18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isObscured,
    required VoidCallback onToggle,
    required BuildContext context,
  }) {
    final isPasswordField = label == "كلمة السر الجديدة";

    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      style: TextStyle(fontSize: context.sp(16)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "هذا الحقل مطلوب";
        }
        if (isPasswordField) {
          if (value.length < 8) {
            return 'لا يجب ان تقل كلمة المرور عن 8';
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
        } else {
          if (value != _passwordController.text) {
            return 'كلمة المرور غير متطابقة';
          }
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: context.sp(14)),
        prefixIcon: Icon(Icons.lock_outline_rounded, size: context.sp(24)),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: context.sp(24),
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(
          vertical: context.hp(2),
          horizontal: context.wp(3),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade100),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "يرجى تصحيح الحقول أولاً",
            style: TextStyle(fontSize: Responsive.sp(context, 14)),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final forgotState = ref.read(forgotPasswordProvider);
    if (forgotState.email.trim().isEmpty || forgotState.otp.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "يرجى إدخال البريد والرمز أولاً",
            style: TextStyle(fontSize: Responsive.sp(context, 14)),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await ref
        .read(forgotPasswordProvider.notifier)
        .resetPassword(_passwordController.text);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "تم تحديث كلمة السر بنجاح",
            style: TextStyle(fontSize: Responsive.sp(context, 14)),
          ),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/login');
    } else {
      final message =
          ref.read(forgotPasswordProvider).errorMessage ??
          "فشل تحديث كلمة المرور تحقق من الرمز";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(fontSize: Responsive.sp(context, 14)),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
