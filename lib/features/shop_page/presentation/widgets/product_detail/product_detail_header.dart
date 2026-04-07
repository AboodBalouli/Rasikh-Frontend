import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class ProductDetailHeader extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ProductDetailHeader({
    super.key,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.wp(2.5)),
      child: Column(
        children: [
          const SizedBox(height: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomBackButton(),
              SizedBox(
                width: context.wp(35),
                height: context.wp(35),
                child: Padding(
                  padding: EdgeInsets.all(context.wp(3.5)),
                  child: Image.asset(
                    'assets/images/logobg.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              _buildCircularButton(
                context,
                onTap: onFavoriteToggle,
                icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                iconColor: isFavorite
                    ? const Color.fromARGB(255, 115, 148, 107)
                    : const Color.fromARGB(255, 83, 125, 93),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(
    BuildContext context, {
    required VoidCallback onTap,
    required IconData icon,
    Color iconColor = const Color.fromARGB(255, 98, 79, 61),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.wp(3)),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 5),
          ],
        ),
        child: Icon(icon, size: context.sp(28), color: iconColor),
      ),
    );
  }
}
