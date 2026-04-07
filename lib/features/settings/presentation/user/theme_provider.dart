import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeColorNotifier extends Notifier<Color> {
  @override
  Color build() => const Color.fromARGB(248, 1, 53, 66);

  void setColor(Color color) {
    state = color;
  }
}

final themeColorProvider = NotifierProvider<ThemeColorNotifier, Color>(() {
  return ThemeColorNotifier();
});
