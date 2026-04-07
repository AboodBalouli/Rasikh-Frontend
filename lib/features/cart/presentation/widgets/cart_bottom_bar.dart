import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/core/constants/custom_button.dart';
import 'package:flutter_application_1/core/constants/app_strings.dart';
import 'package:flutter_application_1/core/providers/locale_provider.dart';
import 'package:flutter_application_1/core/utils/constants/app_fonts.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class CartBottomBar extends ConsumerWidget {
  final TextEditingController noteController;
  final VoidCallback onCheckout;
  final double totalPrice;
  final bool isCartEmpty;

  /// Whether there are pending cart updates being synced.
  /// When true, the checkout button is disabled.
  final bool hasPendingUpdates;

  const CartBottomBar({
    super.key,
    required this.noteController,
    required this.onCheckout,
    required this.totalPrice,
    this.isCartEmpty = false,
    this.hasPendingUpdates = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch locale to rebuild when language changes
    ref.watch(localeProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            context.wp(6),
            context.hp(3),
            context.wp(6),
            context.hp(5),
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: context.wp(10),
                height: context.hp(0.5),
                margin: EdgeInsets.only(bottom: context.hp(2.5)),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 83, 148, 93),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.totalAmount,
                    style: TextStyle(
                      fontSize: context.sp(16),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFD4AF37),
                    ),
                  ),
                  Text(
                    "${totalPrice.toStringAsFixed(2)} ${AppStrings.jd}",
                    style: TextStyle(
                      fontSize: context.sp(20),
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFD4AF37),
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.hp(3)),

              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () => context.pop(),
                      text: AppStrings.addMore,
                      height: context.hp(6),
                      isOutlined: true,
                      textStyle: TextStyle(
                        fontFamily: AppFonts.parastoo,
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: context.wp(4)),
                  Expanded(
                    child: CustomButton(
                      onPressed: (isCartEmpty || hasPendingUpdates)
                          ? () {}
                          : onCheckout,
                      text: AppStrings.proceedToCheckout,
                      height: context.hp(6),
                      textStyle: TextStyle(
                        fontFamily: AppFonts.parastoo,
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
