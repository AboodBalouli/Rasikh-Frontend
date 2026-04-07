import 'package:flutter/material.dart';

class ShopTabs extends StatelessWidget {
  final int selectedTab;
  final VoidCallback onProductsTap;
  final VoidCallback onStoreInfoTap;
  final VoidCallback onSpecialOrdersTap;

  const ShopTabs({
    super.key,
    required this.selectedTab,
    required this.onProductsTap,
    required this.onStoreInfoTap,
    required this.onSpecialOrdersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      padding: const EdgeInsets.all(6),
      // The outer "Track" for the tabs
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.04), // Very light grey track
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          _buildTab("المنتجات", 0, onProductsTap),
          _buildTab("معلومات المتجر", 1, onStoreInfoTap),
          _buildTab("طلبات خاصة", 2, onSpecialOrdersTap),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index, VoidCallback onTap) {
    final isSelected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            // Selected tab gets the "Pill" look
            color: isSelected
                ? const Color.fromARGB(255, 83, 125, 93)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        83,
                        125,
                        93,
                      ).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 15, // Slightly smaller for better fit in pills
              ),
            ),
          ),
        ),
      ),
    );
  }
}
