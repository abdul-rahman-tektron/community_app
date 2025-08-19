import 'package:community_app/modules/customer/payment/payment_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_checkbox.dart';
import 'package:community_app/utils/widgets/custom_drawer.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatelessWidget {
  final int? jobId;
  const PaymentScreen({super.key, this.jobId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PaymentNotifier(jobId),
      child: Consumer<PaymentNotifier>(
        builder: (context, paymentNotifier, child) {
          return buildBody(context, paymentNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, PaymentNotifier paymentNotifier) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildServiceDetails(context, paymentNotifier),
            buildPriceBreakdown(context, paymentNotifier),
            buildPromoCodeField(context, paymentNotifier),
            buildPaymentMethod(context, paymentNotifier),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
              child: Divider(),
            ),
            if (paymentNotifier.isCardSelected) buildCardDetails(context, paymentNotifier),
            if (paymentNotifier.isCardSelected)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                child: Divider(),
              ),
            buildContactInfo(context, paymentNotifier),
            buildTermsAndConditions(context, paymentNotifier),
            buildPayButton(context, paymentNotifier),
          ],
        ),
      ),
    );
  }

  Widget buildServiceDetails(BuildContext context, PaymentNotifier notifier) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeadingWithGradientUnderline(context),
          10.verticalSpace,
          _infoRow("Service Name", "Laundry Service"),
          _infoRow("Assigned", "John's Laundry Express"),
          10.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.calendar,
            label: "21 July 2025",
            bgColor: Color(0xffe7f3f9),
            iconColor: Colors.blue,
          ),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.mapPin,
            label: "Al Barsha, Deira, Dubai Main Road",
            bgColor: Color(0xfffdf5e7),
            iconColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildHeadingWithGradientUnderline(BuildContext context) {
    final text = "Service Details";
    final style = AppFonts.text16.semiBold.style;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: style),
        2.verticalSpace,
        _buildGradientUnderline(text, style),
      ],
    );
  }

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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(label, style: AppFonts.text14.regular.style)),
          Expanded(
              child: Text(value, style: AppFonts.text14.bold.style)),
        ],
      ),
    );
  }

  Widget _infoPriceRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(label, style: AppFonts.text14.regular.style)),
          Text(value, style: AppFonts.text14.bold.style),
        ],
      ),
    );
  }

  Widget buildPriceBreakdown(BuildContext context, PaymentNotifier notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Price Breakdown", style: AppFonts.text16.semiBold.style),
          10.verticalSpace,
          _infoPriceRow("Service Charge", "AED 50.00"),
          _infoPriceRow("Product Price", "AED 15.00"),
          _infoPriceRow("VAT (5%)", "AED 3.25"),
          Divider(),
          _infoPriceRow("TOTAL", "AED 68.25"),
        ],
      ),
    );
  }

  Widget buildPromoCodeField(BuildContext context, PaymentNotifier notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: CustomTextField(
              controller: notifier.promoCodeController,
              fieldName: "Promo Code",
              skipValidation: true,
            ),
          ),

          10.horizontalSpace,
          CustomButton(
            onPressed: () {},
            fullWidth: false,
            backgroundColor: AppColors.white,
            borderColor: AppColors.secondary,
            textStyle: AppFonts.text14.regular.style,
            text: "Apply",
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget buildPaymentMethod(BuildContext context, PaymentNotifier notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Payment Method", style: AppFonts.text16.semiBold.style),
          15.verticalSpace,
          GestureDetector(
            onTap: () => notifier.togglePaymentMethod(true),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: notifier.isCardSelected
                  ? AppStyles.commonDecoration.copyWith(border: Border.all(color: AppColors.primary, width: 1))
                  : AppStyles.commonDecoration,
              child: Row(
                children: [
                  CustomRoundCheckbox(
                    value: notifier.isCardSelected,
                    onChanged: (_) => notifier.togglePaymentMethod(true),
                  ),
                  const SizedBox(width: 12),
                  Text("Credit / Debit Card", style: AppFonts.text14.regular.style),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => notifier.togglePaymentMethod(false),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: !notifier.isCardSelected
                  ? AppStyles.commonDecoration.copyWith(border: Border.all(color: AppColors.primary, width: 1))
                  : AppStyles.commonDecoration,

              child: Row(
                children: [
                  CustomRoundCheckbox(
                    value: !notifier.isCardSelected,
                    onChanged: (_) => notifier.togglePaymentMethod(false),
                  ),
                  const SizedBox(width: 12),
                  Text("Tabby", style: AppFonts.text14.regular.style),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardDetails(BuildContext context, PaymentNotifier notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Card Details", style: AppFonts.text16.semiBold.style),
          15.verticalSpace,
          CustomTextField(controller: notifier.cardNumberController, fieldName: "Card Number", skipValidation: true),
          10.verticalSpace,
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: notifier.expiryDateController,
                  fieldName: "Expiry Date",
                  skipValidation: true,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: CustomTextField(controller: notifier.cvvController, fieldName: "CVV", skipValidation: true),
              ),
            ],
          ),
          10.verticalSpace,
          CustomTextField(
            controller: notifier.cardHolderNameController,
            fieldName: "Cardholder Name",
            skipValidation: true,
          ),
          15.verticalSpace,
          // GestureDetector(
          //   onTap: () => notifier.toggleSaveCard(),
          //   child: Row(
          //     children: [
          //       10.horizontalSpace,
          //       Container(
          //         width: 20,
          //         height: 20,
          //         decoration: BoxDecoration(
          //           border: Border.all(color: AppColors.primary, width: 1.5),
          //           borderRadius: BorderRadius.circular(6),
          //           color: notifier.saveCard ? AppColors.white : Colors.transparent,
          //         ),
          //         child: notifier.saveCard ? Icon(LucideIcons.check, size: 17, color: Colors.black) : null,
          //       ),
          //       10.horizontalSpace,
          //       Text("Save this card for future use"),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildContactInfo(BuildContext context, PaymentNotifier notifier) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Contact Info", style: AppFonts.text16.semiBold.style),
          10.verticalSpace,
          _infoRow("Phone Number", "+971 43763483784"),
          _infoRow("Email Address", "arbkan@mohammed.com"),
        ],
      ),
    );
  }

  Widget buildTermsAndConditions(BuildContext context, PaymentNotifier notifier) {
    final isExpanded = notifier.isTermsExpanded;

    final termsList = [
      "You agree to pay the full amount as displayed.",
      "No refunds are applicable once the payment is made.",
      "Your card details will be securely stored (if selected).",
      "This service is subject to availability.",
      "We are not liable for delays due to external conditions.",
      "Your contact info may be used for transactional updates.",
      "By using this service, you accept all terms listed.",
    ];

    final visibleItems = isExpanded ? termsList : termsList.take(3);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...visibleItems.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ", style: TextStyle(fontSize: 14)),
                  Expanded(child: Text(item, style: AppFonts.text14.regular.style)),
                ],
              ),
            ),
          ),
          5.verticalSpace,
          InkWell(
            onTap: notifier.toggleTermsExpanded,
            child: Text(
              isExpanded ? "Show less" : "Show more",
              style: AppFonts.text14.medium.style.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPayButton(BuildContext context, PaymentNotifier notifier) {
    return Padding(
      padding: EdgeInsets.all(15.w),
      child: CustomButton(onPressed: () {
        notifier.apiUpdateJobStatus(context, AppStatus.paymentCompleted.id);
      }, text: "PAY AED 68.25"),
    );
  }
}
