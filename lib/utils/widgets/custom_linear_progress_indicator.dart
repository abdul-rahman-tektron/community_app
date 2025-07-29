import 'package:community_app/res/colors.dart';
import 'package:flutter/material.dart';

class CustomLinearProgressIndicator extends StatelessWidget {
  final double percentage; // 0 to 100
  final double height;
  final double spacing;
  final int segmentCount;
  final Color fillColor; // single color for all segments
  final Color backgroundColor;

  const CustomLinearProgressIndicator({
    super.key,
    required this.percentage,
    this.segmentCount = 4,
    this.height = 8,
    this.spacing = 4.0,
    this.fillColor = AppColors.primary, // default: green
    this.backgroundColor = const Color(0xFFE6E6E6), // light grey background
  });

  @override
  Widget build(BuildContext context) {
    final clampedPercent = percentage.clamp(0, 100);
    final percentPerSegment = 100 / segmentCount;
    final fullSegments = clampedPercent ~/ percentPerSegment;
    final partialFillRatio = (clampedPercent % percentPerSegment) / percentPerSegment;

    return Row(
      children: List.generate(segmentCount, (index) {
        final isFull = index < fullSegments;
        final isPartial = index == fullSegments && partialFillRatio > 0;

        return Expanded(
          child: Container(
            height: height,
            margin: EdgeInsets.only(right: index == segmentCount - 1 ? 0 : spacing),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: isFull
                ? Container(
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(4),
              ),
            )
                : isPartial
                ? FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: partialFillRatio,
              child: Container(
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),
        );
      }),
    );
  }
}
