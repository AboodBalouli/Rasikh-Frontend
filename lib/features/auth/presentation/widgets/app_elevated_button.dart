// import 'package:flutter/material.dart';

// class AppElevatedButton extends StatelessWidget {
//   const AppElevatedButton({
//     required this.onPressed,
//     required this.text,
//     this.suffixIcon,
//     super.key,
//   });

//   final void Function()? onPressed;
//   final Widget? suffixIcon;
//   final String? text;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         child: Text(text!),
//       ),
//     );
//   }
// }
import 'dart:ui';
import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
    required this.onPressed,
    required this.text,
    this.suffixIcon,
    super.key,
  });

  final void Function()? onPressed;
  final Widget? suffixIcon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isEnabled ? 1.0 : 0.5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 330,
            height: 48, // Smaller, sleeker height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF53945D).withOpacity(0.8),
                  const Color(0xFF53945D).withOpacity(0.6),
                ],
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (suffixIcon != null) ...[
                      const SizedBox(width: 8),
                      suffixIcon!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}