import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/core/utils/constants/app_fonts.dart';

class MadeWithLove extends StatelessWidget {
  final Color? color;
  final double? fontSize;

  const MadeWithLove({super.key, this.color, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.rasikh,
      style: TextStyle(
        color: color ?? TColors.textPrimary,
        fontFamily: AppFonts.parastoo,
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
