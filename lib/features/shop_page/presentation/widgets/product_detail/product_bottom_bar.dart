import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';

class ProductBottomBar extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAddToCart;
  final double price;
  final GlobalKey addKey;

  const ProductBottomBar({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToCart,
    required this.price,
    required this.addKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.hp(13),
      margin: EdgeInsets.fromLTRB(
        context.wp(4),
        0,
        context.wp(4),
        context.hp(3.5),
      ), // Floating effect
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: context.wp(4)),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7), // Glass effect
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                // 1. Modern Quantity Selector (White Pill)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.wp(2),
                    vertical: context.hp(1),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _buildRoundButton(context, Icons.remove, onDecrement),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.wp(4),
                        ),
                        child: Text(
                          "$quantity",
                          style: TextStyle(
                            fontSize: context.sp(18),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      _buildRoundButton(
                        context,
                        Icons.add,
                        onIncrement,
                        key: addKey,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: context.wp(3)),

                // 2. Main Add to Cart Button (Gradient Pill)
                Expanded(
                  child: GestureDetector(
                    onTap: onAddToCart,
                    child: Container(
                      height: context.hp(7),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 202, 224, 197),
                            Color.fromARGB(255, 83, 125, 93),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              255,
                              162,
                              173,
                              171,
                            ).withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "\$${(price * (quantity == 0 ? 1 : quantity)).toStringAsFixed(2)} | إضافة",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: context.sp(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundButton(
    BuildContext context,
    IconData icon,
    VoidCallback onTap, {
    Key? key,
  }) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: context.sp(20), color: const Color(0xFF5EB2A4)),
      ),
    );
  }
}
