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

  // Create a lighter version of the given color
  Color _lighten(Color color, [double amount = 0.3]) {
    final hsl = HSLColor.fromColor(color);
    final lightened = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return lightened.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final clampedPercent = percentage.clamp(0, 100);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: double.infinity,
        color: backgroundColor,
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: clampedPercent / 100,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _lighten(fillColor, 0.3), // Lighter at start
                  fillColor,                // Darker at end
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
