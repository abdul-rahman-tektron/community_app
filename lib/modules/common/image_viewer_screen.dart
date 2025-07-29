import 'dart:io';

import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  final File imageFile;
  const ImageViewerScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.file(imageFile),
        ),
      ),
    );
  }
}