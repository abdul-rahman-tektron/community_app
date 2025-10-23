import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/customer/job/customer_history_detail_request.dart';
import 'package:community_app/core/model/customer/job/customer_history_detail_response.dart';
import 'package:community_app/core/model/customer/payment/payment_detail_request.dart';
import 'package:community_app/core/model/customer/payment/payment_detail_response.dart';
import 'package:community_app/core/remote/services/customer/customer_jobs_repository.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/utils/helpers/pdf_viewer.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';

class HistoryDetailNotifier extends BaseChangeNotifier {
  int? jobId;
  int? vendorId;

  CustomerHistoryDetailData? customerHistoryDetailData;

  PaymentDetailResponse paymentDetail = PaymentDetailResponse();

  List<ImagePair> imagePairs = [];
  List<CompletionDetail> completionDetails = []; // <-- Add this

  /// Job Info
  String status = "";

  HistoryDetailNotifier(this.jobId, this.vendorId) {
    initializeData();
  }

  Future<void> initializeData() async {
    await loadUserData();
    await fetchCustomerHistoryDetail();
    await apiPaymentDetails();
  }

  Future<void> fetchCustomerHistoryDetail() async {
    try {
      isLoading = true;
      final response = await CustomerJobsRepository.instance.apiCustomerHistoryDetails(
        CustomerHistoryDetailRequest(customerId: userData?.customerId ?? 0, jobId: jobId ?? 0),
      );

      if (response is CustomerHistoryDetailResponse && response.success == true) {
        customerHistoryDetailData = response.data;

        // Decode images once here
        completionDetails = customerHistoryDetailData?.completionDetails?.map((detail) {
          return CompletionDetail(
            beforePhotoBytes: detail.beforePhotoUrl != null ? base64Decode(detail.beforePhotoUrl!) : null,
            afterPhotoBytes: detail.afterPhotoUrl != null ? base64Decode(detail.afterPhotoUrl!) : null,
            isVideo: detail.isVideo ?? false,
          );
        }).toList() ?? [];

      } else {
        customerHistoryDetailData = null;
        completionDetails = [];
      }
    } catch (e) {
      print("Error fetching customer history jobs: $e");
      customerHistoryDetailData = null;
      completionDetails = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Call Vendor
  Future<void> openDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (!await launchUrl(launchUri)) {
      throw 'Could not launch $phoneNumber';
    }
  }

  Future<void> apiPaymentDetails() async {
    try {
      final result = await CustomerJobsRepository.instance.apiPaymentDetail(
          PaymentDetailRequest(vendorId: vendorId, jobId: jobId));

      if (result is PaymentDetailResponse) {
        paymentDetail = result;
      }
    } catch (e) {
      print("result error");
      print(e);
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Currency formatter
  final NumberFormat _aed = NumberFormat.currency(locale: 'en_AE', name: 'AED ', decimalDigits: 2);
  String _money(num v) => _aed.format(v.toDouble());

// Line math
  num _linePreVat(LineItem it) {
    final q = it.quantity ?? 0;
    if (q == 0) return it.rate ?? 0;                 // qty==0 → use rate
    if (it.amount != null) return it.amount!;        // prefer server amount
    return (it.rate ?? 0) * q;                       // fallback: rate * qty
  }

  num _lineVat(LineItem it) => (it.vat ?? 0);

  num _lineTotal(LineItem it) => _linePreVat(it) + _lineVat(it);

// Totals
  num _subTotal(Iterable<LineItem> items) => items.fold<num>(0, (s, it) => s + _linePreVat(it));
  num _vatTotal(Iterable<LineItem> items) => items.fold<num>(0, (s, it) => s + _lineVat(it));
  num _grandTotal(Iterable<LineItem> items) => _subTotal(items) + _vatTotal(items);


  Future<Uint8List> generateInvoicePdf() async {
    final pdf = pw.Document();

    final lexend = pw.Font.ttf(await rootBundle.load("assets/fonts/Lexend-Regular.ttf"));
    final lexendBold = pw.Font.ttf(await rootBundle.load("assets/fonts/Lexend-Regular.ttf"));
    final droidKufi = pw.Font.ttf(await rootBundle.load("assets/fonts/DroidKufi-Regular.ttf"));

    final companyLogo = paymentDetail.company?.logoUrl != null && paymentDetail.company!.logoUrl!.isNotEmpty
        ? pw.MemoryImage(base64Decode(paymentDetail.company!.logoUrl!))
        : null;

    final vendor   = paymentDetail.vendor;
    final customer = paymentDetail.customer;
    final job      = paymentDetail.job;
    final items    = paymentDetail.lineItems ?? <LineItem>[];

    // 🔢 Compute totals locally (rules: qty==0 → use rate; else amount or rate*qty)
    final subTotal = _subTotal(items);
    final vatTotal = _vatTotal(items);
    final grand    = subTotal + vatTotal;

    pw.TextStyle pdfTextStyle(String text, {double size = 12, bool bold = false}) {
      final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
      return pw.TextStyle(
        font: isArabic ? droidKufi : (bold ? lexendBold : lexend),
        fontSize: size,
      );
    }

    final logo = pw.MemoryImage((await rootBundle.load(AppImages.logo)).buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          pw.Center(child: pw.Text("TAX INVOICE", style: pdfTextStyle("INVOICE", size: 20, bold: true))),
          pw.SizedBox(height: 20),

          // Header (unchanged except null-safety tweaks)
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Image(logo, width: 60, height: 60),
                      pw.SizedBox(width: 10),
                      pw.Text("Xception", style: pdfTextStyle("Xception", size: 24, bold: true)),
                    ],
                  ),
                  pw.SizedBox(height: 15),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text("Invoice #: ${paymentDetail.invoiceNumber ?? '-'}", style: pdfTextStyle("Invoice #", size: 10)),
                  pw.Text(
                    "Invoice Date: ${paymentDetail.invoiceDate != null ? DateFormat('dd MMM yyyy').format(paymentDetail.invoiceDate!) : '-'}",
                    style: pdfTextStyle("Invoice Date", size: 10),
                  ),
                ],
              ),
            ],
          ),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Vendor (sample/fixed text kept as in your code)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Vendor Details", style: pdfTextStyle("Vendor Details", size: 14, bold: true)),
                  pw.SizedBox(height: 5),
                  pw.Text("CoolFix Maintenance LLC", style: pdfTextStyle("CoolFix Maintenance LLC", size: 12)),
                  pw.Text("Office 123, Dubai, UAE", style: pdfTextStyle("Office 123, Dubai, UAE", size: 12)),
                  pw.Text("support@coolfix.com", style: pdfTextStyle("support@coolfix.com", size: 12)),
                  pw.Text("+971 50 123 4567", style: pdfTextStyle("+971 50 123 4567", size: 12)),
                  pw.Text("TRN: 1234567000000000", style: pdfTextStyle("TRN: 1234567000000000", size: 12)),
                ],
              ),
              // Company (bank) block
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (companyLogo != null) pw.Image(companyLogo, width: 60, height: 60),
                  pw.SizedBox(height: 5),
                  pw.Text(paymentDetail.company?.name ?? '-', style: pdfTextStyle("Company Name", size: 14, bold: true)),
                  pw.Text(paymentDetail.company?.bankDetails?.bankName ?? '-', style: pdfTextStyle("Bank", size: 12)),
                  pw.Text("Account Name: ${paymentDetail.company?.bankDetails?.accountName ?? '-'}", style: pdfTextStyle("Account Name", size: 12)),
                  pw.Text("Account Number: ${paymentDetail.company?.bankDetails?.accountNumber ?? '-'}", style: pdfTextStyle("Account Number", size: 12)),
                  pw.Text("IBAN: ${paymentDetail.company?.bankDetails?.iban ?? '-'}", style: pdfTextStyle("IBAN", size: 12)),
                ],
              ),
            ],
          ),

          pw.Divider(height: 30, thickness: 1),

          // Customer & Job
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Billed To:", style: pdfTextStyle("Billed To:", size: 12, bold: true)),
                  pw.Text(customer?.name ?? '-', style: pdfTextStyle(customer?.name ?? '-', size: 10)),
                  pw.Text(customer?.address ?? '-', style: pdfTextStyle(customer?.address ?? '-', size: 10)),
                  pw.Text(customer?.email ?? '-', style: pdfTextStyle(customer?.email ?? '-', size: 10)),
                  pw.Text(customer?.phone ?? '-', style: pdfTextStyle(customer?.phone ?? '-', size: 10)),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text("Service: ${job?.serviceName ?? '-'}", style: pdfTextStyle("Service", size: 10)),
                  pw.Text("Job Ref: ${job?.jobRef ?? '-'}", style: pdfTextStyle("Job Ref", size: 10)),
                  pw.Text("Requested: ${job?.requestedDate != null ? DateFormat('dd MMM yyyy').format(job!.requestedDate!) : '-'}", style: pdfTextStyle("Requested", size: 10)),
                  pw.Text("Completed: ${job?.completedDate ?? '-'}", style: pdfTextStyle("Completed", size: 10)),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 20),

          /// 🔹 TABLE — use computed values for Amount, VAT, Total
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Sr NO",       style: pdfTextStyle("Sr NO", size: 10, bold: true))),
                  pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Description",  style: pdfTextStyle("Description", size: 10, bold: true))),
                  pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Qty",          style: pdfTextStyle("Qty", size: 10, bold: true))),
                  pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Rate",         style: pdfTextStyle("Rate", size: 10, bold: true))),
                  pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Amount",       style: pdfTextStyle("Amount", size: 10, bold: true))),
                  pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("VAT",          style: pdfTextStyle("VAT", size: 10, bold: true))),
                  pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Total",        style: pdfTextStyle("Total", size: 10, bold: true))),
                ],
              ),
              ...items.map((it) {
                final preVat = _linePreVat(it);
                final vat    = _lineVat(it);
                final total  = preVat + vat;

                return pw.TableRow(
                  children: [
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("${it.srNo ?? '-'}",             style: pdfTextStyle("${it.srNo}", size: 10))),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(it.description ?? '-',           style: pdfTextStyle(it.description ?? '-', size: 10))),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("${it.quantity ?? 0}",           style: pdfTextStyle("${it.quantity ?? 0}", size: 10))),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(_money(it.rate ?? 0),            style: pdfTextStyle("rate", size: 10))),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(_money(preVat),                  style: pdfTextStyle("amount", size: 10))),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(_money(vat),                     style: pdfTextStyle("vat", size: 10))),
                    pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(_money(total),                   style: pdfTextStyle("total", size: 10))),
                  ],
                );
              }),
            ],
          ),

          pw.SizedBox(height: 20),

          /// 🔹 TOTALS — all computed locally
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Keep words if server sends them, else print computed numerics
                  pw.Text("VAT Amount in words: ${paymentDetail.totals?.vatInWords ?? _money(vatTotal)}",   style: pdfTextStyle("VAT Amount", size: 10)),
                  pw.Text("Total Amount in words: ${paymentDetail.totals?.totalInWords ?? _money(grand)}",  style: pdfTextStyle("Total Amount", size: 10)),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text("Sub Total: ${_money(subTotal)}",                    style: pdfTextStyle("Sub Total", size: 10)),
                  pw.Text("VAT: ${_money(vatTotal)}",                           style: pdfTextStyle("VAT", size: 10)),
                  pw.Text("Total: ${_money(grand)}",                            style: pdfTextStyle("Grand Total", size: 10, bold: true)),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 40),
          pw.Center(
            child: pw.Text(
              "Disclaimer: This is a digital invoice and does not require a physical signature.",
              style: pdfTextStyle("Disclaimer", size: 10),
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
