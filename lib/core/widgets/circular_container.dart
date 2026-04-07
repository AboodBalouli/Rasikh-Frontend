import 'package:flutter/material.dart';
import 'dart:ui';

class CircularContainer extends StatelessWidget {
  final double? width, height;
  final double radius;
  final Color color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsets? margin;
  final Widget? child;

  const CircularContainer({
    super.key,
    this.width,
    this.height,
    this.radius = 30,
    this.padding,
    this.margin,
    this.child,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color.withValues(alpha: 0.7),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
      ),
      child: child,
        ),
      ),
    );
  }
}
