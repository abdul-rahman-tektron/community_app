import 'dart:io';

import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/utils/helpers/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PreviousDetailNotifier extends BaseChangeNotifier {
  final int jobId;

  /// States
  bool isLoading = true;

  /// Job Info
  String serviceName = "";
  String customerName = "";
  String status = "";
  String jobRef = "";
  String requestedDate = "";
  String? completedDate;
  String priority = "";

  /// Vendor Info
  String vendorName = "";
  String vendorPhone = "";

  /// Work Details
  List<ImagePair> imagePairs = [];
  String notes = "";

  /// Billing
  double totalAmount = 0.0;
  String paymentMethod = "";

  /// Feedback
  bool hasFeedback = false;
  double vendorRating = 0;
  String vendorReview = "";

  double serviceRating = 0;
  String serviceReview = "";

  PreviousDetailNotifier(this.jobId) {
    _init();
  }

  Future<void> _init() async {
    await fetchJobDetails();
  }

  /// Fetch job details from API
  Future<void> fetchJobDetails() async {
    try {
      isLoading = true;
      notifyListeners();

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      // Sample mock data
      serviceName = "Painting";
      status = "Completed";
      jobRef = "JOB-$jobId";
      requestedDate = "2025-08-01";
      completedDate = "2025-08-03";
      priority = "High";
      customerName = "Abdul Rahman";

      vendorName = "CoolFix Maintenance LLC";
      vendorPhone = "+971 55 123 4567";

      imagePairs = [
        ImagePair(
          before:
          "https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/primary/ProductShowcasesampleimages/JPEG/Product+Showcase-1.jpg",
          after:
          "https://www.seoclerk.com/pics/407226-2eWiCl1471372939.jpg",
        ),
      ];
      notes = "The painting was completed as requested. Applied 2 coats of paint and replaced damaged wallpaper.";

      totalAmount = 250.0;
      paymentMethod = "Credit Card";

      hasFeedback = true; // set false if no feedback
      vendorRating = 4;
      serviceRating = 4.5;
      vendorReview = "Great service experience! The technician arrived on time and resolved the issue professionally.";
      serviceReview =
      "Thank you for choosing CoolFix Maintenance. We appreciate your cooperation during the service visit.";
    } catch (e) {
      debugPrint("Error fetching job details: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Call Vendor
  void callVendor() {
    // TODO: Implement call functionality (use url_launcher)
    debugPrint("Calling $vendorPhone...");
  }

  /// Rebook the same service
  void rebookService() {
    // TODO: Navigate to booking screen with pre-filled service info
    debugPrint("Rebooking service: $serviceName");
  }

  /// Raise an issue
  void raiseIssue(BuildContext context) {
    // TODO: Navigate to complaint/issue form
    debugPrint("Raise issue for job $jobRef");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Raise issue clicked")),
    );
  }

  /// Add feedback
  Future<void> addFeedback(BuildContext context) async {
    // TODO: Open a feedback dialog/screen
    debugPrint("Opening feedback form...");
    // Example: After feedback submitted
    hasFeedback = true;
    vendorRating = 5;
    vendorReview = "Updated feedback: Excellent service!";
    notifyListeners();
  }

  Future<Uint8List> generateInvoicePdf() async {
    final pdf = pw.Document();

    final lexend = pw.Font.ttf(await rootBundle.load("assets/fonts/Lexend-Regular.ttf"));
    final lexendBold = pw.Font.ttf(await rootBundle.load("assets/fonts/Lexend-Regular.ttf")); // Use bold font file if available
    final droidKufi = pw.Font.ttf(await rootBundle.load("assets/fonts/DroidKufi-Regular.ttf"));

    pw.TextStyle pdfTextStyle(String text, {double size = 12, bool bold = false}) {
      final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
      return pw.TextStyle(
        font: isArabic ? droidKufi : (bold ? lexendBold : lexend),
        fontSize: size,
      );
    }

    final logo = pw.MemoryImage(
      (await rootBundle.load(AppImages.logo)).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // TOP SECTION: Logo + X10 Solutions + Vendor + Receiver & Service Details
          pw.Center(
            child: pw.Text("TAX INVOICE",
                style: pdfTextStyle("INVOICE", size: 20, bold: true)),
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              // Left side: Logo + X10 Solutions + Vendor details + Bank details below
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Logo + Name
                  pw.Row(
                    children: [
                      pw.Image(logo, width: 60, height: 60),
                      pw.SizedBox(width: 10),
                      pw.Text(
                        "Xception",
                        style: pdfTextStyle("X10 Solutions", size: 24, bold: true),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 15),
                ],
              ),
              pw.Column(
                children: [
                  pw.Text("Invoice #: INV-2025-0001", style: pdfTextStyle("Invoice #: INV-2025-0001", size: 10)),
                  pw.Text("Invoice Date: 05 Aug 2025", style: pdfTextStyle("Invoice Date: 05 Aug 2025", size: 10)),
                ]
              )
            ],
          ),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Vendor details
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [

                  pw.Text("Vendor Details",
                      style: pdfTextStyle("Vendor Details", size: 14, bold: true)),
                  pw.SizedBox(height: 5),
                  pw.Text("CoolFix Maintenance LLC",
                      style: pdfTextStyle("CoolFix Maintenance LLC", size: 12)),
                  pw.Text("Office 123, Dubai, UAE",
                      style: pdfTextStyle("Office 123, Dubai, UAE", size: 12)),
                  pw.Text("support@coolfix.com",
                      style: pdfTextStyle("support@coolfix.com", size: 12)),
                  pw.Text("+971 50 123 4567",
                      style: pdfTextStyle("+971 50 123 4567", size: 12)),
                  pw.Text("TRN: 1234567000000000",
                      style: pdfTextStyle("TRN: 1234567000000000", size: 12)),
                ],
              ),
              // Right side: Receiver Details + Service details + Quotation + Total
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 15),
                  pw.Text("Bank Details",
                      style: pdfTextStyle("Bank Details", size: 14, bold: true)),
                  pw.SizedBox(height: 5),
                  pw.Text("Bank: ABC Bank", style: pdfTextStyle("Bank: ABC Bank", size: 10)),
                  pw.Text("Account Name: X10 Solutions",
                      style: pdfTextStyle("Account Name: X10 Solutions", size: 10)),
                  pw.Text("Account Number: 123456789",
                      style: pdfTextStyle("Account Number: 123456789", size: 10)),
                  pw.Text("IBAN: AE07 1234 5678 9012 3456 7890",
                      style: pdfTextStyle("IBAN: AE07 1234 5678 9012 3456 7890", size: 10)),
                ],
              ),
            ]
          ),

          pw.Divider(height: 30, thickness: 1),

          /// CUSTOMER & JOB DETAILS
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Billed To:", style: pdfTextStyle("Billed To:", size: 12, bold: true)),
                  pw.SizedBox(height: 4),
                  pw.Text("John Doe", style: pdfTextStyle("John Doe", size: 10)),
                  pw.Text("Palm Jumeirah, Dubai", style: pdfTextStyle("Palm Jumeirah, Dubai", size: 10)),
                  pw.Text("john@example.com", style: pdfTextStyle("john@example.com", size: 10)),
                  pw.Text("+971 55 111 2222", style: pdfTextStyle("+971 55 111 2222", size: 10)),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text("Service: AC Repair & Service", style: pdfTextStyle("Service: AC Repair & Service", size: 10)),
                  pw.Text("Job Ref: JOB-98765", style: pdfTextStyle("Job Ref: JOB-98765", size: 10)),
                  pw.Text("Requested: 01 Aug 2025", style: pdfTextStyle("Requested: 01 Aug 2025", size: 10)),
                  pw.Text("Completed: 04 Aug 2025", style: pdfTextStyle("Completed: 04 Aug 2025", size: 10)),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 20),

          /// TABLE - Line Items
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("Sr NO", style: pdfTextStyle("Sr NO", size: 10, bold: true)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("Description", style: pdfTextStyle("Description", size: 10, bold: true)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("Qty", style: pdfTextStyle("Qty", size: 10, bold: true)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("Rate", style: pdfTextStyle("Rate", size: 10, bold: true)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("Amount", style: pdfTextStyle("Amount", size: 10, bold: true)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("VAT", style: pdfTextStyle("Vat Amount", size: 10, bold: true)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("Total", style: pdfTextStyle("Total", size: 10, bold: true)),
                  ),
                ],
              ),
              // Data row 1
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("1", style: pdfTextStyle("1", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("AC Gas Refill", style: pdfTextStyle("AC Gas Refill", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("1", style: pdfTextStyle("1", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("200.00", style: pdfTextStyle("200.00", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("200.00", style: pdfTextStyle("200.00", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("10.00", style: pdfTextStyle("10.00", size: 10)), // Example VAT amount
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("210.00", style: pdfTextStyle("210.00", size: 10)),
                  ),
                ],
              ),
              // Data row 2
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("2", style: pdfTextStyle("2", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("Filter Replacement", style: pdfTextStyle("Filter Replacement", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("2", style: pdfTextStyle("2", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("50.00", style: pdfTextStyle("50.00", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("100.00", style: pdfTextStyle("100.00", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("5.00", style: pdfTextStyle("5.00", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("105.00", style: pdfTextStyle("105.00", size: 10)),
                  ),
                ],
              ),
              // Data row 3
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("3", style: pdfTextStyle("3", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("Labor Charge", style: pdfTextStyle("Labor Charge", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("-", style: pdfTextStyle("-", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("-", style: pdfTextStyle("-", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("300.00", style: pdfTextStyle("300.00", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("15.00", style: pdfTextStyle("15.00", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("315.00", style: pdfTextStyle("315.00", size: 10)),
                  ),
                ],
              ),
              // Data row 4
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("4", style: pdfTextStyle("4", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("Service Charge", style: pdfTextStyle("Service Charge", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("-", style: pdfTextStyle("-", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("-", style: pdfTextStyle("-", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("200.00", style: pdfTextStyle("200.00", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("10.00", style: pdfTextStyle("10.00", size: 10)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("210.00", style: pdfTextStyle("210.00", size: 10)),
                  ),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 20),

          /// TOTALS
          pw.Container(
            width: double.infinity,
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                // LEFT SIDE - Amount in words
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "VAT Amount in words",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        "FORTY AED",
                        style: pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        "Total Amount in words",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        "EIGHT HUNDRED AND FORTY AED",
                        style: pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ]
                  )
                ),
                pw.SizedBox(width: 20),
                // RIGHT SIDE - Totals
                pw.Expanded(
                  flex: 1,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Sub Total", style: pw.TextStyle(fontSize: 10)),
                          pw.Text("AED 800.00", style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                      pw.SizedBox(height: 4),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("VAT(5%)", style: pw.TextStyle(fontSize: 10)),
                          pw.Text("AED 40.00", style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                      pw.SizedBox(height: 4),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            top: pw.BorderSide(width: 0.5, color: PdfColors.grey),
                          ),
                        ),
                        padding: const pw.EdgeInsets.only(top: 2),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              "Total",
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              "AED 840.00",
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 40),

          // Disclaimer footer centered
          pw.Center(
            child: pw.Text(
              "Disclaimer: This is a digital invoice and does not require a physical signature.",
              style: pdfTextStyle(
                "Disclaimer: This is a digital invoice and does not require a physical signature.",
                size: 10,
                bold: false,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  Future<String> saveInvoicePdf() async {
    final pdfBytes = await generateInvoicePdf();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/Invoice_${DateTime
        .now()
        .millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(pdfBytes);
    return file.path;
  }

  Future<void> openInvoice(BuildContext context) async {
    final filePath = await saveInvoicePdf();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PdfPreviewScreen(filePath: filePath)),
    );
  }
}

/// Helper model for images
class ImagePair {
  final String before;
  final String after;
  final bool isVideo;

  ImagePair({required this.before, required this.after, this.isVideo = false});
}
