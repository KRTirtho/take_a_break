import 'package:flutter/material.dart';

extension ThemeDataIsDarkMode on ThemeData {
  bool get isDarkMode => colorScheme.brightness == Brightness.dark;
  bool get isLightMode => colorScheme.brightness == Brightness.light;
}

extension ThemeDataTextColors on ColorScheme {
  bool get isDarkMode => brightness == Brightness.dark;
  bool get isLightMode => brightness == Brightness.light;

  Color get baseText => isLightMode ? Colors.grey[850]! : Colors.white;
  Color get subtitleText => isLightMode ? Colors.grey[700]! : Colors.grey[300]!;
}

extension ImageColor on ColorScheme {
  Color get imageBlend => isLightMode ? primaryContainer : primary;
}
