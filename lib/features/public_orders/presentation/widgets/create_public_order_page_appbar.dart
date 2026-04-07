import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';

class CreatePublicOrderPageAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const CreatePublicOrderPageAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color.fromARGB(255, 83, 148, 93);

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            backgroundColor: Colors.white.withOpacity(0.7),
            elevation: 0,
            leading: const CustomBackButton(),
            title: const Text(
              'إضافة طلب عام',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: primaryGreen,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
    );
  }
}
