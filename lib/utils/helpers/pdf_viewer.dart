import 'dart:io';

import 'package:community_app/res/colors.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
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
            child: Icon(LucideIcons.share2, size: 25, color: AppColors.white),
            onPressed: () async {
              await Share.shareXFiles([XFile(filePath)], text: 'Invoice');
            },
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            backgroundColor: AppColors.primary,
            shape: const CircleBorder(),
            heroTag: 'downloadBtn',
            child: Icon(LucideIcons.arrowDownToLine, size: 25, color: AppColors.white),
            onPressed: () async {
              // Replace this with your actual PDF bytes
              final List<int> pdfBytes = await generatePdfBytes(); // async PDF generator

              // Filename with date-time
              final dateTime = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
              final fileName = 'invoice_$dateTime.pdf';

              Directory? directory;

              if (Platform.isAndroid) {
                // Request storage permission
                if (!await Permission.storage.request().isGranted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("Storage permission denied")));
                  return;
                }

                // Downloads folder
                directory = Directory('/storage/emulated/0/Download/Community App Invoice');
                if (!await directory.exists()) {
                  await directory.create(recursive: true);
                }
              } else if (Platform.isIOS) {
                // App Documents folder
                directory = await getApplicationDocumentsDirectory();
                directory = Directory('${directory.path}/Community App Invoice');
                if (!await directory.exists()) {
                  await directory.create(recursive: true);
                }
              }

              final file = File('${directory?.path}/$fileName');
              await file.writeAsBytes(pdfBytes);

              print("Directory Saved Location");
              print("${directory?.path}/$fileName");

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("PDF saved to ${directory?.path}/$fileName")));
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

  Future<List<int>> generatePdfBytes() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (context) => pw.Center(child: pw.Text("This is your invoice"))));
    return pdf.save();
  }
}
