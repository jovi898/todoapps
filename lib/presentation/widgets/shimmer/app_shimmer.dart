import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as shimmer;
import 'package:todoapp/core/constants/app_colors.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const AppShimmer({required this.child, this.baseColor, this.highlightColor, super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = this.baseColor ?? AppColors.grey;
    final highlightColor = this.highlightColor ?? AppColors.white;
    return shimmer.Shimmer(
      gradient: LinearGradient(
        colors: <Color>[baseColor, baseColor, highlightColor, baseColor, baseColor],
        stops: const <double>[0.0, 0.35, 0.5, 0.65, 1.0],
      ),
      child: child,
    );
  }
}
