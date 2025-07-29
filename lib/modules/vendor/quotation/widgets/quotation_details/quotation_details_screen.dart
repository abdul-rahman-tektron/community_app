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
  const QuotationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuotationDetailsNotifier(),
      child: Consumer<QuotationDetailsNotifier>(
        builder: (context, notifier, _) {
          return Scaffold(
            appBar: CustomAppBar(),
            drawer: CustomDrawer(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  buildTitle(context, notifier),
                  _buildCustomerInfo(context, notifier),
                  Divider(),
                  10.verticalSpace,
                  _buildQuotationTable(context, notifier),
                  10.verticalSpace,
                  Divider(),
                  10.verticalSpace,
                  buildNotes(notifier.notes),
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

  Widget buildTitle(BuildContext context, QuotationDetailsNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Quotation Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          _buildBackButton(context),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.textPrimary, width: 1.5),
          ),
          child: Icon(LucideIcons.arrowLeft),
        ),
      ),
    );
  }

  Widget _buildCustomerInfo(BuildContext context, QuotationDetailsNotifier notifier) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      width: double.infinity,
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notifier.customerName, style: AppFonts.text16.semiBold.style),
          5.verticalSpace,
          Text(notifier.serviceName, style: AppFonts.text14.regular.style),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.phone,
            label: notifier.phone,
            bgColor: const Color(0xffeff7ef),
            iconColor: Colors.green,
          ),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.mapPin,
            label: notifier.location,
            bgColor: const Color(0xffe7f3f9),
            iconColor: Colors.blue,
          ),
          5.verticalSpace,
          Text("Requested Date: ${notifier.requestedDate}", style: AppFonts.text14.regular.style),
          10.verticalSpace,
          Row(
            children: [
              Text("Status: ", style: AppFonts.text14.regular.style),
              Text(
                notifier.status.name.toCapitalize(),
                style: AppFonts.text14.semiBold.style.copyWith(
                  color: notifier.status.color,
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Job Description: ",
                  style: AppFonts.text14.semiBold.style, // Bold for "Remarks:"
                ),
                TextSpan(
                  text: "We’re planning to repaint three bedrooms. One of them has old wallpaper that needs to be removed first. The other two just need surface preparation and a fresh coat of paint. We’d like durable, washable paint since we have young kids. Colors will be provided once the quote is finalized.",
                  style: AppFonts.text14.regular.style, // Regular for content
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotationTable(BuildContext context, QuotationDetailsNotifier notifier) {
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
          ...notifier.quotationItems.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  Expanded(child: Text(item.product)),
                  SizedBox(width: 50, child: Text(item.qty.toString())),
                  SizedBox(width: 80, child: Text(item.unitPrice.toStringAsFixed(2))),
                  SizedBox(width: 85, child: Text(item.lineTotal.toStringAsFixed(2))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildNotes(String notes) {
    if (notes.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Notes:", style: AppFonts.text14.semiBold.style),
          const SizedBox(height: 8),
          Text(
            notes,
            style: AppFonts.text14.regular.style,
          ),
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
          Divider(thickness: 1),
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
