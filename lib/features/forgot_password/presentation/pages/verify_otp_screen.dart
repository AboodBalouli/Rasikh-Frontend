import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import '../controllers/forgot_password_controller.dart';

class VerifyOTPScreen extends ConsumerStatefulWidget {
  const VerifyOTPScreen({super.key});

  @override
  ConsumerState<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends ConsumerState<VerifyOTPScreen> {
  final int _otpLength = 6;
  late final List<TextEditingController> _otpControllers;
  Timer? _timer;
  int _start = 30;
  bool _canResend = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(_otpLength, (_) => TextEditingController());
    _startTimer();
  }

  void _startTimer() {
    _canResend = false;
    _start = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(forgotPasswordProvider);
    final email = authState.email;

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
          child: Column(
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
                  Icons.mark_email_read_outlined,
                  size: context.sp(60),
                  color: const Color.fromARGB(255, 83, 148, 93),
                ),
              ),
              SizedBox(height: context.hp(4)),
              Text(
                "التحقق من الرمز",
                style: TextStyle(
                  fontSize: context.sp(23),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: context.hp(1.5)),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: context.sp(16),
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text: "أدخل الرمز المكون من 6 أرقام الذي أرسلناه إلى\n",
                    ),
                    TextSpan(
                      text: email,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 83, 148, 93),
                        fontWeight: FontWeight.bold,
                        fontSize: context.sp(16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.hp(5)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  _otpLength,
                  (index) => _buildOtpBox(context, index),
                ),
              ),

              SizedBox(height: context.hp(1.5)),

              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),

              SizedBox(height: context.hp(3.5)),

              SizedBox(
                width: double.infinity,
                height: context.hp(7),
                child: ElevatedButton(
                  onPressed: () {
                    final otp = _otpControllers.map((c) => c.text).join();
                    if (otp.length != _otpLength) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'يرجى إدخال الرمز كاملاً',
                            style: TextStyle(fontSize: context.sp(14)),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    ref.read(forgotPasswordProvider.notifier).updateOtp(otp);
                    context.push('/new-password');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 83, 148, 93),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "تأكيد الرمز",
                    style: TextStyle(
                      fontSize: context.sp(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: context.hp(3)),

              TextButton(
                onPressed: _canResend
                    ? () async {
                        await ref
                            .read(forgotPasswordProvider.notifier)
                            .sendOtp();
                        _startTimer();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "تم إعادة إرسال الرمز بنجاح",
                                style: TextStyle(fontSize: context.sp(14)),
                              ),
                            ),
                          );
                        }
                      }
                    : null,
                child: Text(
                  _canResend
                      ? "إعادة إرسال الرمز"
                      : "إعادة إرسال خلال $_start ثانية",
                  style: TextStyle(
                    color: _canResend
                        ? const Color.fromARGB(255, 83, 148, 93)
                        : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(BuildContext context, int index) {
    return Container(
      width: context.wp(13), // Adjusted for 6 items on screen
      height: context.hp(8), // Proportional height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8FBF9), Color(0xFFFDFEFE)],
        ),
        border: Border.all(color: const Color(0xFFE0E6EC), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _otpControllers[index],
        onChanged: (value) {
          if (value.length == 1) {
            setState(() {
              _errorMessage = '';
            });
            if (index < _otpLength - 1) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          } else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        style: TextStyle(
          fontSize: context.sp(20),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: const Color.fromARGB(255, 83, 148, 93),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: context.hp(2.5),
          ), // Center text vertically roughly
          border: InputBorder.none,
          counterText: "",
        ),
      ),
    );
  }
}
