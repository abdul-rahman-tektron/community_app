import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapIconHelper {

  static Future<BitmapDescriptor> createCustomMarkerIcon({
    required IconData iconData,
    required Color backgroundColor,
    required Color iconColor,
    double size = 80,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final width = size;
    final height = size * 1.4;
    final centerX = width / 2;
    final circleRadius = width / 2.5;
    final circleCenterY = width / 2.5 + 10;

    final path = Path();

    // Draw full pin shape (circle + bottom point) as one path
    path.moveTo(centerX, height); // bottom point
    path.quadraticBezierTo(
      centerX + circleRadius,
      circleCenterY + 10,
      centerX + circleRadius,
      circleCenterY,
    );
    path.arcToPoint(
      Offset(centerX - circleRadius, circleCenterY),
      radius: Radius.circular(circleRadius),
      clockwise: false,
    );
    path.quadraticBezierTo(
      centerX - circleRadius,
      circleCenterY + 10,
      centerX,
      height,
    );
    path.close();

    final paint = Paint()
      ..color = backgroundColor;
    canvas.drawPath(path, paint);

    // Draw icon in center of circular area
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          fontSize: size / 1.8,
          fontFamily: iconData.fontFamily,
          package: iconData.fontPackage,
          color: iconColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final iconOffset = Offset(
      centerX - textPainter.width / 2,
      circleCenterY - textPainter.height / 2,
    );
    textPainter.paint(canvas, iconOffset);

    final picture = recorder.endRecording();
    final image = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> createCustomTransitIcon({
    required Color backgroundColor,
    required Color iconColor,
    double size = 70,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final center = Offset(size / 2, size / 2);

    // Draw glowing outer circle
    final outerPaint = Paint()
      ..color = backgroundColor.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, size / 2, outerPaint);

    // Draw solid inner circle
    final innerPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, size / 3, innerPaint);

    // Draw icon text

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }
}