import 'dart:convert';

import 'package:community_app/core/model/common/dropdown/service_dropdown_response.dart';
import 'package:community_app/modules/vendor/onboard/vendor_onboard_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/helpers/dashed_border_container.dart';
import 'package:community_app/utils/helpers/loader.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class VendorOnboardScreen extends StatelessWidget {
  final bool? isEdit;

  const VendorOnboardScreen({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VendorOnboardNotifier(isEdit),
      child: Consumer<VendorOnboardNotifier>(
        builder: (context, vendorOnboardNotifier, child) {
          return LoadingOverlay<VendorOnboardNotifier>(
            child: buildBody(context, vendorOnboardNotifier),
          );
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, VendorOnboardNotifier vendorOnboardNotifier) {
    return Scaffold(
      appBar: CustomAppBar(showBackButton: (isEdit ?? false) ? true : false),
      persistentFooterButtons: [_buildSubmitButton(context, vendorOnboardNotifier)],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildServiceChips(vendorOnboardNotifier),
            const SizedBox(height: 20),
            if (vendorOnboardNotifier.selectedService != null)
              _buildServiceDetails(vendorOnboardNotifier.selectedService!, vendorOnboardNotifier),
            if (!(isEdit ?? true)) const SizedBox(height: 20),
            if (!(isEdit ?? true)) _buildLogoUpload(vendorOnboardNotifier),
            if (!(isEdit ?? true)) const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// Header
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Welcome Aboard!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        10.verticalSpace,
        Text(
          "Let’s help you list your jobs. Start by selecting a category and then describe the specific jobs you offer.",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  /// Single-select service chips with completed color
  Widget _buildServiceChips(VendorOnboardNotifier vendorOnboardNotifier) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: vendorOnboardNotifier.serviceData.map((service) {
        final isSelected = vendorOnboardNotifier.selectedService == service;
        final isCompleted = vendorOnboardNotifier.isServiceCompleted(service);
        return ChoiceChip(
          label: Text(service.serviceName ?? ""),
          selected: isSelected,
          selectedColor: Colors.blue.shade100,
          backgroundColor: isCompleted ? Colors.green.shade100 : Colors.grey.shade200,
          labelStyle: TextStyle(
            color: isCompleted ? Colors.green.shade800 : Colors.black,
            fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
          ),
          onSelected: (selected) {
            vendorOnboardNotifier.setSelectedService(service);
          },
        );
      }).toList(),
    );
  }

  /// Service details: Description + Image Upload + Done button
  Widget _buildServiceDetails(
    ServiceDropdownData service,
    VendorOnboardNotifier vendorOnboardNotifier,
  ) {
    final controller = vendorOnboardNotifier.descriptionController;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: AppStyles.commonDecoration,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service.serviceName ?? "",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            10.verticalSpace,
            // Explanatory note
            Text(
              "These are default description and feature image for your service. You can proceed with them or edit as needed. "
              "This description and image will be visible to customers.",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            20.verticalSpace,

            CustomTextField(
              controller: controller,
              isMaxLines: true,
              fieldName: "Description",
              titleVisibility: false,
              hintText:
                  vendorOnboardNotifier.staticDescriptions[service.serviceName ?? ""] ??
                  "Provide a brief overview of your ${service.serviceName ?? ""} service",
            ),
            10.verticalSpace,
            _buildImageUpload(vendorOnboardNotifier, () {
              vendorOnboardNotifier.pickServiceImage();
            }, vendorOnboardNotifier.serviceImagePath),
            const SizedBox(height: 12),
            CustomButton(
              onPressed: vendorOnboardNotifier.doneWithService,
              backgroundColor: AppColors.white,
              borderColor: AppColors.primary,
              textStyle: AppFonts.text14.regular.style,
              text: "Submit",
            ),
          ],
        ),
      ),
    );
  }

  /// Image upload
  Widget _buildImageUpload(
    VendorOnboardNotifier vendorOnboardNotifier,
    VoidCallback onUpload,
    String? imagePath,
  ) {
    return InkWell(
      onTap: onUpload,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        foregroundDecoration: DashedBorder(borderColor: Colors.grey.shade300),
        child: imagePath == null
            ? const Center(
                child: Text(
                  "Upload Image\nRecommended: 500x500px, PNG/JPG",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildImageWidget(vendorOnboardNotifier, imagePath),
              ),
      ),
    );
  }

  Widget _buildImageWidget(VendorOnboardNotifier vendorOnboardNotifier, String imagePath) {
    if (imagePath.startsWith("assets/")) {
      return Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity);
    } else if (_isBase64(imagePath)) {
      Uint8List bytes = base64Decode(imagePath);
      return Image.memory(bytes, fit: BoxFit.cover, width: double.infinity);
    } else {
      return Image.file(
        vendorOnboardNotifier.getFileFromPath(imagePath),
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
  }

  bool _isBase64(String str) {
    // quick check to avoid exceptions
    final base64RegEx = RegExp(r'^[A-Za-z0-9+/=]+\Z');
    return str.isNotEmpty &&
        str.length % 4 == 0 &&
        base64RegEx.hasMatch(str.replaceAll("\n", "").replaceAll("\r", ""));
  }

  /// Logo upload
  Widget _buildLogoUpload(VendorOnboardNotifier vendorOnboardNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload the Company Logo",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        8.verticalSpace,
        _buildImageUpload(vendorOnboardNotifier, () {
          vendorOnboardNotifier.pickLogo();
        }, vendorOnboardNotifier.logoPath),
      ],
    );
  }

  /// Submit button
  Widget _buildSubmitButton(BuildContext context, VendorOnboardNotifier vendorOnboardNotifier) {
    return CustomButton(onPressed: () => vendorOnboardNotifier.submit(context),
        text: isEdit ?? false ? "Back" : "Submit");
  }
}
