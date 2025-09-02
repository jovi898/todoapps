import 'package:flutter/material.dart';
import 'package:todoapp/core/constants/app_colors.dart';

abstract final class AppTextStyles {
  static const boldTextWhite = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
  );

  static const middleTextWhite = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static const borderFocusAndEnabled = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none,
  );
}
