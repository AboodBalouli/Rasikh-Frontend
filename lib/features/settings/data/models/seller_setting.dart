import 'package:flutter/material.dart';

// Model
class SellerSetting {
  final String title;
  final String description;
  final IconData icon;
  final Color? color;

  SellerSetting({
    required this.title,
    required this.description,
    required this.icon,
    this.color,
  });
}
