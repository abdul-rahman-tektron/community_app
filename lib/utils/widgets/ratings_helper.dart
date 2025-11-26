import 'package:Xception/res/colors.dart';
import 'package:flutter/material.dart';


class RatingsHelper extends StatelessWidget {
  final double rating; // e.g., 3.5 or 4.0
  final double size;
  final int maxStars;

  const RatingsHelper({
    super.key,
    required this.rating,
    this.size = 20,
    this.maxStars = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        final starIndex = index + 1;
        if (rating >= starIndex) {
          // Full star
          return Icon(Icons.star, size: size, color: AppColors.secondary);
        } else if (rating >= starIndex - 0.5) {
          // Half star
          return Icon(Icons.star_half, size: size, color: AppColors.secondary);
        } else {
          // Empty star
          return Icon(Icons.star_border, size: size, color: Colors.grey.shade300);
        }
      }),
    );
  }
}
