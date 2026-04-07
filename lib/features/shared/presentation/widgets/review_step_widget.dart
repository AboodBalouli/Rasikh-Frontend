import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class ReviewStepWidget extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onPrevious;
  final String submitButtonText;
  final String previousButtonText;

  const ReviewStepWidget({
    super.key,
    required this.onSubmit,
    required this.onPrevious,
    this.submitButtonText = "ارسال الطلب",
    this.previousButtonText = "رجوع",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.hp(3)),
        Icon(
          Icons.assignment_turned_in_outlined,
          size: context.sp(80),
          color: const Color.fromARGB(255, 151, 130, 94),
        ),
        SizedBox(height: context.hp(2)),
        Text(
          "جاهز للمراجعه ؟",
          style: GoogleFonts.cairo(
            fontSize: context.sp(24),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.hp(1)),
        Text(
          "يرجى التأكد من صحة المعلومات المدخلة قبل الارسال",
          style: GoogleFonts.cairo(
            fontSize: context.sp(16),
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.hp(6)),
        // Submit button
        Container(
          width: double.infinity,
          height: context.hp(7),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 202, 224, 197),
                Color.fromARGB(255, 83, 125, 93),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(
                  255,
                  162,
                  173,
                  171,
                ).withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onSubmit,
              borderRadius: BorderRadius.circular(30),
              child: Center(
                child: Text(
                  submitButtonText,
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: context.sp(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: context.hp(2)),
        // Back button
        Container(
          width: double.infinity,
          height: context.hp(7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color.fromARGB(255, 83, 125, 93),
              width: 2,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPrevious,
              borderRadius: BorderRadius.circular(30),
              child: Center(
                child: Text(
                  previousButtonText,
                  style: GoogleFonts.cairo(
                    color: const Color.fromARGB(255, 83, 125, 93),
                    fontSize: context.sp(16),
                    fontWeight: FontWeight.bold,
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
