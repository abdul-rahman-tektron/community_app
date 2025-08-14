import 'dart:convert';

import 'package:community_app/modules/vendor/quotation/widgets/add_quotation/add_quotation_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_drawer.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class AddQuotationScreen extends StatelessWidget {
  final int? jobId;
  final int? serviceId;
  final int? quotationId;

  const AddQuotationScreen({
    super.key,
    this.jobId,
    this.serviceId,
    this.quotationId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddQuotationNotifier()
        ..jobId = jobId
        ..serviceId = serviceId
        ..quotationId = quotationId,
      child: Consumer<AddQuotationNotifier>(
        builder: (context, addQuotationNotifier, _) {
          return buildBody(context, addQuotationNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, AddQuotationNotifier addQuotationNotifier) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildTitle(context, addQuotationNotifier),
            buildCustomerInfo(context, addQuotationNotifier),
            Divider(),
            buildQuotationInfo(context, addQuotationNotifier),
            Divider(),
            buildNotes(context, addQuotationNotifier),
            buildPrice(context, addQuotationNotifier),
            buildSubmitButton(context, addQuotationNotifier),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext context, AddQuotationNotifier addQuotationNotifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Add Quotation", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          CustomButton(text: "Reject", fullWidth: false, height: 35, onPressed: () {
            addQuotationNotifier.apiUpdateJobStatus(context, AppStatus.vendorQuotationRejected.id);
          }),
        ],
      ),
    );
  }

  Widget buildCustomerInfo(BuildContext context, AddQuotationNotifier addQuotationNotifier) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      width: double.infinity,
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(addQuotationNotifier.jobDetail.customerName ?? "Customer Name", style: AppFonts.text16.semiBold.style),
          5.verticalSpace,
          Text(addQuotationNotifier.jobDetail.serviceName ?? "Service Name", style: AppFonts.text14.regular.style),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.phone,
            label: addQuotationNotifier.jobDetail.phoneNumber ?? "---",
            bgColor: Color(0xffeff7ef),
            iconColor: Colors.green,
          ),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.mapPin,
            label: addQuotationNotifier.jobDetail.address ?? "---",
            bgColor: Color(0xffe7f3f9),
            iconColor: Colors.blue,
          ),
          5.verticalSpace,
          Text("Requested Date: ${addQuotationNotifier.jobDetail.expectedDate?.formatFullDateTime() ?? "00/00/0000"}", style: AppFonts.text14.regular.style),
          10.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Priority: ',
                  style: AppFonts.text14.regular.style,
                ),
                TextSpan(
                  text: addQuotationNotifier.jobDetail.priority ?? "None",
                  style: AppFonts.text14.regular.red.style, // You can change the style here if needed
                ),
              ],
            ),
          ),
          10.verticalSpace,
          if(addQuotationNotifier.jobDetail.fileContent != null)Image.memory(base64Decode(addQuotationNotifier.jobDetail.fileContent ?? ""), height: 100, width: 100, fit: BoxFit.cover,),
          10.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Job Description: ",
                  style: AppFonts.text14.semiBold.style, // Bold for "Remarks:"
                ),
                TextSpan(
                  text: addQuotationNotifier.jobDetail.remarks ?? "Not Added",
                  style: AppFonts.text14.regular.style, // Regular for content
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuotationInfo(BuildContext context, AddQuotationNotifier notifier) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Material Section ---
          Text("Material Details", style: AppFonts.text16.semiBold.style),
          8.verticalSpace,
          _buildQuotationTable(notifier, QuotationItemType.material),

          10.verticalSpace,
          CustomButton(
            fullWidth: false,
            height: 35,
            iconOnLeft: true,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            textStyle: AppFonts.text14.regular.style,
            borderColor: AppColors.primary,
            backgroundColor: AppColors.white,
            icon: LucideIcons.plus,
            onPressed: () => notifier.addItem(type: QuotationItemType.material),
            text: 'Add Material Row',
          ),

          25.verticalSpace,

          // --- Service Section ---
          Text("Service Details", style: AppFonts.text16.semiBold.style),
          8.verticalSpace,
          _buildQuotationTable(notifier, QuotationItemType.service),

          10.verticalSpace,
          CustomButton(
            fullWidth: false,
            height: 35,
            iconOnLeft: true,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            textStyle: AppFonts.text14.regular.style,
            borderColor: AppColors.primary,
            backgroundColor: AppColors.white,
            icon: LucideIcons.plus,
            onPressed: () => notifier.addItem(type: QuotationItemType.service),
            text: 'Add Service Row',
          ),
        ],
      ),
    );
  }

  Widget _buildQuotationTable(AddQuotationNotifier notifier, QuotationItemType type) {
    final filteredItems = notifier.quotationItems.where((item) => item.type == type).toList();

    return Column(
      children: [
        // Header Row: Conditionally render columns depending on type
        Row(
          children: [
            Expanded(
              child: Text(
                type == QuotationItemType.material ? "Description" : "Description",
                style: AppFonts.text14.semiBold.style,
              ),
            ),
            5.horizontalSpace,
            if (type == QuotationItemType.material)
              SizedBox(width: 52, child: Text("Qty", style: AppFonts.text14.semiBold.style)),
            if (type == QuotationItemType.material) 5.horizontalSpace,
            SizedBox(
              width: 100,
              child: Text(
                type == QuotationItemType.material ? "Unit Price" : "Charges",
                style: AppFonts.text14.semiBold.style,
              ),
            ),
            5.horizontalSpace,
            SizedBox(
              width: 90,
              child: Text(
                type == QuotationItemType.material ? "Total" : "Total",
                style: AppFonts.text14.semiBold.style,
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
        5.verticalSpace,

        ...filteredItems.map((item) {
          final index = notifier.quotationItems.indexOf(item);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: item.productController,
                    fieldName: '',
                    titleVisibility: false,
                    skipValidation: true,
                  ),
                ),
                5.horizontalSpace,

                if (item.type == QuotationItemType.material)
                  SizedBox(
                    width: 50,
                    child: CustomTextField(
                      controller: item.qtyController,
                      fieldName: '',
                      titleVisibility: false,
                      skipValidation: true,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => notifier.notifyListeners(),
                    ),
                  ),
                if (item.type == QuotationItemType.material) 5.horizontalSpace,

                SizedBox(
                  width: 100,
                  child: CustomTextField(
                    controller: item.unitPriceController,
                    fieldName: '',
                    titleVisibility: false,
                    skipValidation: true,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => notifier.notifyListeners(),
                  ),
                ),
                10.horizontalSpace,

                SizedBox(width: 90, child: Text(item.lineTotal.toStringAsFixed(2))),

                GestureDetector(
                  onTap: () => notifier.removeItem(index),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget buildNotes(BuildContext context, AddQuotationNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: CustomTextField(
        controller: notifier.notesController,
        isMaxLines: true,
        fieldName: "Notes",
        hintText: "Add any additional notes here",
        titleVisibility: false,
      ),
    );
  }

  Widget buildPrice(BuildContext context, AddQuotationNotifier notifier) {
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

  Widget buildSubmitButton(BuildContext context, AddQuotationNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: CustomButton(
        text: "Submit Quotation",
        onPressed: () async {
          await notifier.submitQuotation(context);
          Navigator.pop(context);
        },
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
