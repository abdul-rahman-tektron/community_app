import 'dart:convert';

import 'package:community_app/modules/vendor/quotation/widgets/quotation_details/quotation_details_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class QuotationDetailScreen extends StatelessWidget {
  final int? jobId;
  final int? quotationResponseId;

  const QuotationDetailScreen({super.key, this.jobId, this.quotationResponseId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuotationDetailsNotifier(jobId, quotationResponseId),
      child: Consumer<QuotationDetailsNotifier>(
        builder: (context, notifier, _) {
          return Scaffold(
            appBar: CustomAppBar(),
            drawer: CustomDrawer(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  buildTitle(context),
                  buildCustomerInfo(context, notifier),
                  const Divider(),
                  10.verticalSpace,
                  _buildQuotationTable(context, notifier), // Replaced table
                  10.verticalSpace,
                  const Divider(),
                  10.verticalSpace,
                  buildNotes(notifier),
                  10.verticalSpace,
                  _buildPrice(context, notifier),
                  if (notifier.isRejected)
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CustomButton(
                        text: "Resend Quotation",
                        onPressed: notifier.resendQuotation,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Quotation Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget buildCustomerInfo(BuildContext context, QuotationDetailsNotifier notifier) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      width: double.infinity,
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notifier.jobDetail.customerName ?? "Customer Name", style: AppFonts.text16.semiBold.style),
          5.verticalSpace,
          Text(notifier.jobDetail.serviceName ?? "Service Name", style: AppFonts.text14.regular.style),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.phone,
            label: notifier.jobDetail.phoneNumber ?? "---",
            bgColor: const Color(0xffeff7ef),
            iconColor: Colors.green,
          ),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.mapPin,
            label: notifier.jobDetail.address ?? "---",
            bgColor: const Color(0xffe7f3f9),
            iconColor: Colors.blue,
          ),
          5.verticalSpace,
          Text("Requested Date: ${notifier.jobDetail.expectedDate?.formatFullDateTime() ?? "00/00/0000"}", style: AppFonts.text14.regular.style),
          10.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Priority: ', style: TextStyle(fontSize: 14)),
                TextSpan(
                  text: notifier.jobDetail.priority ?? "None",
                  style: AppFonts.text14.regular.red.style,
                ),
              ],
            ),
          ),
          10.verticalSpace,
          if (notifier.jobDetail.fileContent != null)
            Image.memory(
              base64Decode(notifier.jobDetail.fileContent ?? ""),
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          10.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: "Job Description: ", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: notifier.jobDetail.remarks ?? "Not Added"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotationTable(BuildContext context, QuotationDetailsNotifier notifier) {
    final items = notifier.quotationDetail.items ?? [];

    print("items dataa");
    print(items);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Quotation Breakdown", style: AppFonts.text16.semiBold.style),
          15.verticalSpace,
          Row(
            children: [
              Expanded(child: Text("Product", style: AppFonts.text14.semiBold.style)),
              SizedBox(width: 50, child: Text("Qty", style: AppFonts.text14.semiBold.style)),
              SizedBox(width: 80, child: Text("Unit Price", style: AppFonts.text14.semiBold.style)),
              SizedBox(width: 85, child: Text("Line Total", style: AppFonts.text14.semiBold.style)),
            ],
          ),
          10.verticalSpace,
          ...items.map((item) {
            final product = item.product ?? "";
            final quantity = item.quantity ?? "-";
            final price = item.price ?? 0.0;
            final totalAmount = item.totalAmount ?? 0.0;

            print("Product: $product");
            print("Quantity: $quantity");
            print("Price: $price");
            print("Total Amount: $totalAmount");

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  Expanded(child: Text(product)),
                  SizedBox(width: 50, child: Text(quantity == 0 ? "-" : quantity.toString())),
                  SizedBox(width: 80, child: Text(price.toStringAsFixed(2))),
                  SizedBox(width: 85, child: Text(totalAmount.toStringAsFixed(2))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Widget _buildItemRow(QuotationItemModel item, {required bool isService}) {
  //   final lineTotal = item.lineTotal;
  //
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Expanded(flex: 4, child: Text(item.product, style: const TextStyle(fontSize: 14))),
  //         Expanded(flex: 3, child: Text("AED ${item.unitPrice.toStringAsFixed(2)}", textAlign: TextAlign.right)),
  //         Expanded(flex: 3, child: Text("AED ${lineTotal.toStringAsFixed(2)}", textAlign: TextAlign.right)),
  //       ],
  //     ),
  //   );
  // }

  Widget buildNotes(QuotationDetailsNotifier notifier) {
    if (notifier.quotationDetail.quotationDetails?.trim().isEmpty ?? false) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Notes:", style: AppFonts.text14.semiBold.style),
          const SizedBox(height: 8),
          Text(notifier.quotationDetail.quotationDetails ?? "", style: AppFonts.text14.regular.style),
        ],
      ),
    );
  }

  Widget _buildPrice(BuildContext context, QuotationDetailsNotifier notifier) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _priceRow("Subtotal", "AED ${notifier.subTotal.toStringAsFixed(2)}"),
          _priceRow("VAT (5%)", "AED ${notifier.vat.toStringAsFixed(2)}"),
          const Divider(thickness: 1),
          _priceRow("Grand Total", "AED ${notifier.grandTotal.toStringAsFixed(2)}", isBold: true),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isBold ? AppFonts.text16.semiBold.style : AppFonts.text14.regular.style),
          Text(value, style: isBold ? AppFonts.text16.semiBold.style : AppFonts.text14.regular.style),
        ],
      ),
    );
  }

  Widget _iconLabelRow({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Row(
      children: [
        _iconBox(icon: icon, bgColor: bgColor, iconColor: iconColor),
        10.horizontalSpace,
        Expanded(child: Text(label, style: AppFonts.text14.regular.style)),
      ],
    );
  }

  Widget _iconBox({required IconData icon, required Color bgColor, required Color iconColor}) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}
