import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/utils/constants/app_fonts.dart';

class WishlistAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WishlistAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Center(child: CustomBackButton()),
      title: Column(
        children: [
          Text(
            AppStrings.wishlistTitle,
            style: const TextStyle(
              color: Color.fromARGB(255, 83, 148, 93),
              fontSize: 14,
              fontFamily: AppFonts.parastoo,
            ),
          ),
        ],
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black, size: 28),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
