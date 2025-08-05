import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String filePath;
  const PdfPreviewScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Already saved in storage
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("File saved to Downloads")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              await Share.shareXFiles([XFile(filePath)], text: 'Invoice');
            },
          ),
        ],
      ),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
      ),
    );
  }
}