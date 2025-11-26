import 'dart:convert';
import 'dart:typed_data';
import 'package:Xception/utils/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final String? base64Image;

  const ImageViewer({super.key, required this.base64Image});

  @override
  Widget build(BuildContext context) {
    // Decode base64 string to bytes
    Uint8List imageBytes = base64Decode(base64Image ?? "");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          scaleEnabled: true,
          minScale: 1.0,
          maxScale: 5.0,
          child: Image.memory(imageBytes),
        ),
      ),
    );
  }
}