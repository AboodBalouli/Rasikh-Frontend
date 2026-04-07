import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/constants/app_fonts.dart';

class StepNavigationButtons extends StatelessWidget {
  final VoidCallback onNextPressed;
  final VoidCallback? onPrevPressed;
  final bool showPrevButton;

  const StepNavigationButtons({
    super.key,
    required this.onNextPressed,
    this.onPrevPressed,
    this.showPrevButton = true,
  });

  @override
  Widget build(BuildContext context) {
    if (showPrevButton) {
      return Row(
        children: [
          Expanded(
            child: Container(
              height: 60,
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
                  onTap: onNextPressed,
                  borderRadius: BorderRadius.circular(30),
                  child: const Center(
                    child: Text(
                      "التالي",
                      style: TextStyle(
                        fontFamily: AppFonts.parastoo,
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 60,
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
                  onTap: onPrevPressed,
                  borderRadius: BorderRadius.circular(30),
                  child: const Center(
                    child: Text(
                      "رجوع",
                      style: TextStyle(
                        fontFamily: AppFonts.parastoo,
                        color: Color.fromARGB(255, 83, 125, 93),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      height: 60,
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
          onTap: onNextPressed,
          borderRadius: BorderRadius.circular(30),
          child: const Center(
            child: Text(
              "التالي",
              style: TextStyle(
                fontFamily: AppFonts.parastoo,
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
