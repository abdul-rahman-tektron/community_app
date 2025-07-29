import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingStarHelper {
  static Widget buildRatingStars({
    required double rating,
    double iconSize = 16,
    Color filledColor = Colors.orange,
    Color unfilledColor = Colors.grey,
    MainAxisAlignment alignment = MainAxisAlignment.start,
  }) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(Icon(Icons.star, size: iconSize.sp, color: filledColor));
      } else if (i == fullStars && hasHalfStar) {
        stars.add(Icon(Icons.star_half, size: iconSize.sp, color: filledColor));
      } else {
        stars.add(Icon(Icons.star_border, size: iconSize.sp, color: unfilledColor));
      }
    }

    return Row(
      mainAxisAlignment: alignment,
      children: stars,
    );
  }

  static String getStatus(double rating) {
    if (rating >= 4.5) return "Excellent";
    if (rating >= 4.0) return "Very Good";
    if (rating >= 3.0) return "Good";
    if (rating >= 2.0) return "Average";
    return "Poor";
  }

  static Color getStatusColor(double rating) {
    if (rating >= 4.5) return Colors.green.shade700;
    if (rating >= 4.0) return Colors.green.shade500;
    if (rating >= 3.0) return Colors.orange.shade600;
    if (rating >= 2.0) return Colors.orange.shade800;
    return Colors.red.shade600;
  }
}
