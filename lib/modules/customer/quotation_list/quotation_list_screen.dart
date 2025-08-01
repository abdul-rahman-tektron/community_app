import 'package:community_app/core/model/vendor/quotation_request/quotation_request_list_response.dart';
import 'package:community_app/modules/customer/quotation_list/quotation_list_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class QuotationListScreen extends StatelessWidget {
  const QuotationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuotationListNotifier(),
      child: Consumer<QuotationListNotifier>(
        builder: (_, notifier, __) {
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(),
              body: notifier.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : notifier.jobs.isEmpty
                  ? const Center(child: Text("No jobs found"))
                  : SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [_buildHeader()],
                    ),
                    ...List.generate(
                      notifier.jobs.length,
                          (i) => _buildJobCard(context, notifier, i, notifier.jobs[i]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: Icon(LucideIcons.arrowLeft),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Text("Quotation List", style: AppFonts.text20.semiBold.style),
          _buildGradientUnderline("Quotation List", AppFonts.text20.semiBold.style),
        ],
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, QuotationListNotifier notifier, int index, QuotationRequestListData job) {
    final quotations = job.jobQuotationRequest ?? [];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: AppStyles.commonDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Job ID: ${job.jobId}', style: AppFonts.text14.medium.style),
          _buildUnderline(),

          quotations.isEmpty
              ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                "Quotation not provided yet",
                style: AppFonts.text14.semiBold.red.style,
              ),
            ),
          )
              : Column(
            children: quotations.map((model) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVendorInfo("Sample Vendor", "VND101", model.quotationId?.toString() ?? "-"),
                  _buildUnderline(),
                  if (model.hasQuotationResponse == true) ...[
                    _buildQuotationItemsStatic(),
                    _buildServiceCharge(50),
                    _buildTotalWithVat(200),
                    _buildSiteVisitRequired(true),
                    _buildCompletionAvailability("2 Days", "12 Jul", "10:00 AM"),
                    _buildFooterActions(context, notifier, index),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          "Quotation not provided yet",
                          style: AppFonts.text14.semiBold.red.style,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 16),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // The rest of your widgets remain unchanged (like _buildVendorInfo, _buildQuotationItemsStatic, etc.)

  Widget _buildGradientUnderline(String text, TextStyle style) {
    final textWidth = _getTextWidth(text, style);
    return Container(
      height: 2,
      width: textWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.primary.withOpacity(0.5),
            AppColors.primary,
            AppColors.primary.withOpacity(0.5),
            Colors.transparent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }

  Widget _buildUnderline() {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.primary),
    );
  }

  Widget _buildQuotationItemsStatic() {
    final items = [
      {"qty": "2", "name": "AC Filter", "price": 30},
      {"qty": "1", "name": "Coolant", "price": 40},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quotation Items:', style: AppFonts.text12.medium.style),
        8.verticalSpace,
        ...items.map(
              (item) => _quotationItem(
            item["qty"].toString(),
            item["name"].toString(),
            'AED ${(item["price"] as num).toStringAsFixed(2)}',
          ),
        ),
      ],
    );
  }

  Widget _buildVendorInfo(String vendorName, String vendorId, String quotationId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Vendor: $vendorName ($vendorId)', style: AppFonts.text14.medium.style),
        10.verticalSpace,
        Row(
          children: [
            _iconBadge(LucideIcons.receiptText, Colors.blue, const Color(0xffe7f3f9)),
            6.horizontalSpace,
            Text(quotationId, style: AppFonts.text12.regular.grey.style),
          ],
        ),
      ],
    );
  }

  Widget _quotationItem(String qty, String name, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                _quantityTag(qty),
                10.horizontalSpace,
                Text(name, style: AppFonts.text12.regular.style),
              ],
            ),
          ),
          Text(price, style: AppFonts.text12.semiBold.style),
        ],
      ),
    );
  }

  Widget _buildServiceCharge(double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Service Charge', style: AppFonts.text12.regular.style),
          Text('AED ${amount.toStringAsFixed(2)}', style: AppFonts.text12.semiBold.style),
        ],
      ),
    );
  }

  Widget _buildTotalWithVat(double total) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total (Incl. VAT)', style: AppFonts.text14.semiBold.style),
          Text('AED ${total.toStringAsFixed(2)}', style: AppFonts.text14.semiBold.red.style),
        ],
      ),
    );
  }

  Widget _buildSiteVisitRequired(bool required) {
    return Row(
      children: [
        Text('Site Visit Required:', style: AppFonts.text12.regular.grey.style),
        5.horizontalSpace,
        Icon(required ? LucideIcons.check : LucideIcons.x, color: required ? Colors.green : Colors.red, size: 18),
      ],
    );
  }

  Widget _buildCompletionAvailability(String completion, String date, String time) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                _iconBadge(LucideIcons.clock, Colors.orange, const Color(0xfffdf5e7)),
                4.horizontalSpace,
                Text(completion, style: AppFonts.text12.regular.grey.style),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _iconBadge(LucideIcons.calendar, Colors.green, const Color(0xffeff7ef)),
                4.horizontalSpace,
                Text('$date, $time', style: AppFonts.text12.regular.grey.style),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterActions(BuildContext context, QuotationListNotifier notifier, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              height: 40,
              onPressed: () {
                bookingConfirmationPopup(context);
              },
              backgroundColor: AppColors.white,
              borderColor: AppColors.primary,
              textStyle: AppFonts.text14.regular.style,
              text: 'Accept',
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: CustomButton(
              height: 40,
              onPressed: () {
                // Decline logic
              },
              backgroundColor: AppColors.white,
              borderColor: AppColors.primary,
              textStyle: AppFonts.text14.regular.style,
              text: 'Decline',
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBadge(IconData icon, Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
      child: Icon(icon, color: iconColor, size: 18),
    );
  }

  Widget _quantityTag(String qty) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      decoration: BoxDecoration(color: const Color(0xFFE6E6E6), borderRadius: BorderRadius.circular(5)),
      child: Text(qty, style: AppFonts.text12.regular.style),
    );
  }
}
