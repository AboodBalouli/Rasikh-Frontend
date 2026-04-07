import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

// Colors matching the home page button
const Color _primaryBlue = Color.fromARGB(255, 84, 111, 139);
const Color _accentBlue = Color.fromARGB(255, 86, 166, 212);
const Color _lightBlue = Color.fromARGB(255, 111, 154, 192);

/// Widget displaying a generated image as a chat bubble.
class ImageMessageBubble extends StatelessWidget {
  final Uint8List imageBytes;
  final String? enhancedPrompt;
  final VoidCallback? onTap;

  const ImageMessageBubble({
    super.key,
    required this.imageBytes,
    this.enhancedPrompt,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: context.wp(3),
          right: context.wp(15),
          bottom: context.hp(1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Avatar
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_accentBlue, _primaryBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _accentBlue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    size: context.sp(14),
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: context.wp(2)),
                Text(
                  'صورة مُولَّدة',
                  style: GoogleFonts.cairo(
                    fontSize: context.sp(12),
                    color: _primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.hp(1)),
            // Image container
            GestureDetector(
              onTap: onTap,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: context.wp(70),
                  maxHeight: context.hp(40),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _lightBlue.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _lightBlue.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.memory(
                    imageBytes,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        padding: EdgeInsets.all(context.wp(8)),
                        color: _lightBlue.withOpacity(0.1),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              size: context.sp(48),
                              color: _lightBlue,
                            ),
                            SizedBox(height: context.hp(1)),
                            Text(
                              'فشل تحميل الصورة',
                              style: GoogleFonts.cairo(color: _primaryBlue),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // Tap to view hint
            Padding(
              padding: EdgeInsets.only(top: context.hp(0.5)),
              child: Text(
                'اضغط للتكبير',
                style: GoogleFonts.cairo(
                  fontSize: context.sp(11),
                  color: _lightBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget displaying a user's prompt as a chat bubble.
class PromptMessageBubble extends StatelessWidget {
  final String prompt;

  const PromptMessageBubble({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(
          right: context.wp(3),
          left: context.wp(15),
          bottom: context.hp(1.5),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: context.wp(4),
          vertical: context.hp(1.5),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_accentBlue, _primaryBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _accentBlue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          prompt,
          style: GoogleFonts.cairo(
            fontSize: context.sp(15),
            color: Colors.white,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
