import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      icon: Icon(
        Icons.arrow_back_ios_new,
        color: const Color.fromARGB(255, 83, 125, 93),
        size: context.sp(20),
      ),
      onPressed: () {
        context.pop();
      },
    );
  }
}
