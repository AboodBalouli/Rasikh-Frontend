import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/utils/constants/app_fonts.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CartAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Center(child: CustomBackButton()),
      title: Column(
        children: [
          Text(
            AppStrings.cartTitle,
            style: TextStyle(
              color: const Color.fromARGB(255, 83, 148, 93),
              fontSize: context.sp(12),
              fontFamily: AppFonts.parastoo,
            ),
          ),
        ],
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
