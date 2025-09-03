import 'package:flutter/material.dart';
import 'package:todoapp/core/constants/app_colors.dart';

class ShimmerPlaceholder extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final Color? color;

  const ShimmerPlaceholder({
    required this.height,
    this.width,
    this.borderRadius = 16,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? AppColors.grey,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
    );
  }
}
