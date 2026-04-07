import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/colors.dart';

class ImageGenerateCard extends StatelessWidget {
  final VoidCallback? onCameraPressed;

  const ImageGenerateCard({super.key, this.onCameraPressed});

  static const _orange = Color.fromARGB(255, 84, 111, 139);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          height: 95,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(
                  255,
                  103,
                  136,
                  163,
                ).withValues(alpha: 0.08),
                const Color.fromARGB(255, 95, 131, 162).withValues(alpha: 0.04),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color.fromARGB(
                255,
                111,
                154,
                192,
              ).withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(
                  255,
                  111,
                  154,
                  192,
                ).withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(
                        255,
                        111,
                        154,
                        192,
                      ).withValues(alpha: 0.15),
                      const Color.fromARGB(
                        255,
                        111,
                        154,
                        192,
                      ).withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        111,
                        154,
                        192,
                      ).withValues(alpha: 0.14),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.smart_toy,
                  size: 36,
                  color: Color.fromARGB(255, 119, 174, 201),
                ),
              ),
              const SizedBox(width: 15),
              // Text Content
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اصنع صورة لطلبك',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: _orange,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '  مستعد لصنع صورة لطلبك بطريقة رائعة',
                      style: TextStyle(
                        fontSize: 13,
                        color: TColors.textSecondary,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Camera Button
              GestureDetector(
                onTap: onCameraPressed,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 86, 166, 212),
                        _orange.withValues(alpha: 0.85),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          86,
                          166,
                          212,
                        ).withValues(alpha: 0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
