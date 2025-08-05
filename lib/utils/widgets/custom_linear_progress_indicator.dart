import 'package:community_app/res/colors.dart';
import 'package:flutter/material.dart';

class CustomLinearProgressIndicator extends StatelessWidget {
  final double percentage; // 0 to 100
  final double height;
  final Color fillColor;
  final Color backgroundColor;
  final double borderRadius;

  const CustomLinearProgressIndicator({
    super.key,
    required this.percentage,
    this.height = 6,
    this.fillColor = AppColors.primary,
    this.backgroundColor = const Color(0xFFE6E6E6),
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final clampedPercent = percentage.clamp(0, 100);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: clampedPercent / 100,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: fillColor,
            ),
          ),
        ),
      ),
    );
  }
}
