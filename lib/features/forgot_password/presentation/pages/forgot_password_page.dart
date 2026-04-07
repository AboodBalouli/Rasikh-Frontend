import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(forgotPasswordProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
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
            child: Column(
              children: [
                SizedBox(height: context.hp(2)),
                Container(
                  height: context.hp(15),
                  width: context.hp(15),
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
                    Icons.lock_reset_rounded,
                    size: context.sp(60),
                    color: const Color.fromARGB(255, 83, 148, 93),
                  ),
                ),
                SizedBox(height: context.hp(4)),
                Text(
                  "نسيت كلمة المرور؟",
                  style: TextStyle(
                    fontSize: context.sp(23),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.hp(1.5)),
                Text(
                  "أدخل بريدك الإلكتروني المسجل وسنرسل لك رمزاً لتحديث كلمة السر الخاصة بك",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: context.sp(16),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: context.hp(5)),
                // حقل الإدخال بتصميم عصري
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: context.sp(16)),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'يرجى إدخال بريد إلكتروني صحيح';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "البريد الإلكتروني",
                    hintStyle: TextStyle(fontSize: context.sp(14)),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      size: context.sp(24),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: EdgeInsets.symmetric(
                      vertical: context.hp(2),
                      horizontal: context.wp(3),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                ),
                SizedBox(height: context.hp(4)),
                // زر الإرسال مع حالة التحميل
                SizedBox(
                  width: double.infinity,
                  height: context.hp(7),
                  child: ElevatedButton(
                    onPressed: authState.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 83, 148, 93),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: authState.isLoading
                        ? SizedBox(
                            height: context.sp(20),
                            width: context.sp(20),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "إرسال الرمز",
                            style: TextStyle(
                              fontSize: context.sp(16),
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

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      ref
          .read(forgotPasswordProvider.notifier)
          .updateEmail(_emailController.text.trim());
      final success = await ref.read(forgotPasswordProvider.notifier).sendOtp();

      if (success && mounted) {
        context.push('/verify-otp');
      }
    }
  }
}
