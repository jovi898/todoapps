import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color green = Color(0xFF008000);
  static const Color blue = Color(0xFF2196F3);
  static const Color yellow = Color(0xFFFFC107);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF808080);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color.fromRGBO(255, 255, 255, 0);
  static const Color transparentHalf = Color.fromRGBO(255, 255, 255, 0.5);
  static const Color red = Color(0xFFFF0000);
  static Color blackWithOpacity = Colors.black.withOpacity(0.3);
  static Color bluekWithOpacity = Colors.blue.withOpacity(0.6);
}
