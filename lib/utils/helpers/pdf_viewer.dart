import 'package:community_app/res/colors.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

class PdfPreviewScreen extends StatelessWidget {
  final String filePath;
  const PdfPreviewScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          heroTag: 'shareBtn',
          child: Icon(LucideIcons.share2, size: 25, color: AppColors.white,),
          onPressed: () async {
            await Share.shareXFiles([XFile(filePath)], text: 'Invoice');
          },
        ),
        const SizedBox(height: 15),
        FloatingActionButton(
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          heroTag: 'downloadBtn',
          child: Icon(LucideIcons.arrowDownToLine, size: 25, color: AppColors.white,),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("File saved to Downloads")),
            );
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