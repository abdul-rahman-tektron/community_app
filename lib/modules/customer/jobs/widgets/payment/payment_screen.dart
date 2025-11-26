import 'package:Xception/core/model/customer/payment/payment_detail_response.dart';
import 'package:Xception/modules/customer/jobs/widgets/payment/payment_notifier.dart';
import 'package:Xception/res/colors.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/res/styles.dart';
import 'package:Xception/utils/extensions.dart';
import 'package:Xception/utils/helpers/common_utils.dart';
import 'package:Xception/utils/widgets/custom_app_bar.dart';
import 'package:Xception/utils/widgets/custom_buttons.dart';
import 'package:Xception/utils/widgets/custom_checkbox.dart';
import 'package:Xception/utils/widgets/custom_drawer.dart';
import 'package:Xception/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatelessWidget {
  final int? jobId;
  final int? vendorId;

  PaymentScreen({super.key, this.jobId, this.vendorId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PaymentNotifier(jobId, vendorId),
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
            if (paymentNotifier.selectedPaymentMethod?.isCard ?? false)
              buildCardDetails(context, paymentNotifier),
            if (paymentNotifier.selectedPaymentMethod?.isCard ?? false)
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
          Row(
            children: [
              Expanded(child: Text("Service Details", style: AppFonts.text16.semiBold.style)),
              Text("#${jobId.toString()}", style: AppFonts.text14.regular.style),
            ],
          ),
          10.verticalSpace,
          _infoRow("Service Name", notifier.paymentDetail.job?.serviceName ?? ""),
          _infoRow("Assigned", notifier.paymentDetail.vendor?.name ?? ""),
          10.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.calendar,
            label: notifier.paymentDetail.job?.requestedDate?.formatDate() ?? "",
            bgColor: Color(0xffe7f3f9),
            iconColor: Colors.blue,
          ),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.mapPin,
            label: notifier.paymentDetail.customer?.address ?? "",
            bgColor: Color(0xfffdf5e7),
            iconColor: Colors.orange,
          ),
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: AppFonts.text14.regular.style)),
          Expanded(child: Text(value, style: AppFonts.text14.bold.style)),
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
          Expanded(child: Text(label, style: AppFonts.text14.regular.style)),
          Text(value, style: AppFonts.text14.bold.style),
        ],
      ),
    );
  }

  Widget buildPriceBreakdown(BuildContext context, PaymentNotifier notifier) {
    final items  = notifier.paymentDetail.lineItems ?? const <LineItem>[];

    // compute locally (prefer BE totals if you REALLY trust them, but you asked to do it from your end)
    final subTotal = _subTotalFromItems(items);
    final vatTotal = _vatFromItems(items);
    final grand    = subTotal + vatTotal;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Price Breakdown", style: AppFonts.text16.semiBold.style),
          10.verticalSpace,

          // Each line shows pre-VAT using qty==0 rule
          ...items.map((item) {
            final q = (item.quantity ?? 0);
            final desc = (q > 0 && (item.rate ?? 0) > 0)
                ? "${item.description ?? ''} (x${q.toStringAsFixed(0)})"
                : (item.description ?? '');
            final preVatLine = _linePreVat(item);
            return _infoPriceRow(desc, money(preVatLine));
          }),

          const Divider(),

          _infoPriceRow("Subtotal", money(subTotal)),
          _infoPriceRow("VAT",      money(vatTotal)),

          const Divider(),
          _infoPriceRow("TOTAL",    money(grand)),
        ],
      ),
    );
  }

  num _linePreVat(LineItem it) {
    final q = it.quantity ?? 0;
    if (q == 0) {
      // qty==0 → take rate
      return it.rate ?? 0;
    }
    // qty>0 → prefer amount, else rate*qty
    if (it.amount != null) return it.amount!;
    return (it.rate ?? 0) * q;
  }

  num _subTotalFromItems(List<LineItem> items) =>
      items.fold<num>(0, (s, it) => s + _linePreVat(it));

  num _vatFromItems(List<LineItem> items) =>
      items.fold<num>(0, (s, it) => s + (it.vat ?? 0));

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

          Column(
            children: notifier.paymentMethods.map((method) {
              final isSelected = notifier.isSelected(method);

              return GestureDetector(
                onTap: () => notifier.selectPaymentMethod(method),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(12.w),
                  decoration: isSelected
                      ? AppStyles.commonDecoration.copyWith(
                          border: Border.all(color: AppColors.primary, width: 1),
                        )
                      : AppStyles.commonDecoration,
                  child: Row(
                    children: [
                      CustomRoundCheckbox(
                        value: isSelected,
                        onChanged: (_) => notifier.selectPaymentMethod(method),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(method.name, style: AppFonts.text14.regular.style)),
                      if (method.iconUrls != null)
                        Row(
                          children: method.iconUrls!.map((icon) {
                            return Image.asset(icon, width: 50, fit: BoxFit.contain);
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
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
          CustomTextField(
            controller: notifier.cardNumberController,
            fieldName: "Card Number",
            skipValidation: true,
          ),
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
                child: CustomTextField(
                  controller: notifier.cvvController,
                  fieldName: "CVV",
                  skipValidation: true,
                ),
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
          _infoRow("Phone Number", notifier.paymentDetail.vendor?.phone ?? ""),
          _infoRow("Email Address", notifier.paymentDetail.vendor?.email ?? ""),
        ],
      ),
    );
  }

  Widget buildTermsAndConditions(BuildContext context, PaymentNotifier notifier) {
    final isExpanded = notifier.isTermsExpanded;

    final termsList = [
      "By proceeding, you authorize us to charge the displayed amount to your selected payment method.",
      "All payments are final and non-refundable unless required by applicable law.",
      // "If you choose to save your card, your details will be securely encrypted and stored in compliance with PCI-DSS standards.",
      "Service fulfillment is subject to availability and scheduling constraints.",
      "We are not responsible for delays or interruptions caused by factors beyond our control (e.g., technical issues, third-party providers).",
      "Your contact details may be used solely for transactional communication and service updates.",
      "By completing this payment, you acknowledge that you have read and agreed to these Terms & Conditions.",
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

  final _aed = NumberFormat.currency(locale: 'en_AE', name: 'AED ', decimalDigits: 2);
  String money(num? v) => _aed.format((v ?? 0).toDouble());

  Widget buildPayButton(BuildContext context, PaymentNotifier notifier) {
    final items  = notifier.paymentDetail.lineItems ?? const <LineItem>[];
    final subTotal = _subTotalFromItems(items);
    final vatTotal = _vatFromItems(items);
    final grand    = subTotal + vatTotal;

    return Padding(
      padding: EdgeInsets.all(15.w),
      child: CustomButton(
        isLoading: notifier.isLoading,
        onPressed: () async {
          notifier.apiCreatePayment(context, overrideGrandTotal: grand.toDouble());
        },
        text: "PAY ${money(grand)}",
      ),
    );
  }
}
