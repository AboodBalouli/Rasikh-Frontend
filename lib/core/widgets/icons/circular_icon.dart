import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/core/constants/sizes.dart';

class CircularIcon extends StatelessWidget {
  const CircularIcon({
    super.key,
    required this.dark,
    required this.icon,
    this.width,
    this.height,
    this.size = Sizes.lg,
    this.onPressed,
    this.color,
    this.backgroundColor,
  });

  final bool dark;
  final IconData icon;
  final double? width, height;
  final double size;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color:
            backgroundColor ??
            (dark
                ? TColors.dark.withValues(alpha: 0.9)
                : TColors.white.withValues(alpha: 0.9)),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: color ?? (dark ? TColors.white : TColors.black),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
