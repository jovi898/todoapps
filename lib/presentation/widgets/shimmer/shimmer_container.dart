import 'package:flutter/material.dart';
import 'package:todoapp/presentation/widgets/shimmer/app_shimmer.dart';
import 'package:todoapp/presentation/widgets/shimmer/shimmer_placeholder.dart';

class ShimmerContainer extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsets padding;
  final Alignment alignment;
  final double borderRadius;

  const ShimmerContainer({
    required this.height,
    this.width = double.infinity,
    this.padding = const EdgeInsets.all(16),
    this.alignment = Alignment.centerLeft,
    this.borderRadius = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: AppShimmer(
          child: ShimmerPlaceholder(width: width, height: height, borderRadius: borderRadius),
        ),
      ),
    );
  }
}
