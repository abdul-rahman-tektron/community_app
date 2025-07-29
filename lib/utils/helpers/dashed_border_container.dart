import 'package:flutter/material.dart';

class DashedBorder extends ShapeDecoration {
  final Color borderColor;
  final double strokeWidth;
  final double dashWidth;
  final double gap;
  final double borderRadius;

  DashedBorder({
    this.borderColor = Colors.black,
    this.strokeWidth = 1,
    this.dashWidth = 6,
    this.gap = 4,
    this.borderRadius = 8,
  }) : super(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    ),
  );

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DashedBorderPainter(
      borderColor,
      strokeWidth,
      dashWidth,
      gap,
      BorderRadius.circular(borderRadius), // Convert to BorderRadius
    );
  }
}

class _DashedBorderPainter extends BoxPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double gap;
  final BorderRadius borderRadius;

  _DashedBorderPainter(
      this.color,
      this.strokeWidth,
      this.dashWidth,
      this.gap,
      this.borderRadius,
      );

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    if (configuration.size == null) return;

    final rect = offset & configuration.size!;
    final rrect = borderRadius.toRRect(rect);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()..addRRect(rrect);
    final dashedPath = _createDashedPath(path);
    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source) {
    final Path dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dest.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + gap;
      }
    }
    return dest;
  }
}
