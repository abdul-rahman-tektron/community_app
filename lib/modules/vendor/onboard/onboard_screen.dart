import 'package:community_app/core/model/common/dropdown/service_dropdown_response.dart';
import 'package:community_app/modules/vendor/onboard/onboard_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/helpers/dashed_border_container.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnboardNotifier(),
      child: Consumer<OnboardNotifier>(
        builder: (context, onboardNotifier, child) {
          return buildBody(context, onboardNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, OnboardNotifier onboardNotifier) {
    return Scaffold(
      appBar: AppBar(title: const Text("List Your Services"), centerTitle: true),
      persistentFooterButtons: [
        _buildSubmitButton(onboardNotifier),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildServiceChips(onboardNotifier),
            const SizedBox(height: 20),
            if (onboardNotifier.selectedService != null)
              _buildServiceDetails(onboardNotifier.selectedService!, onboardNotifier),
            const SizedBox(height: 20),
            _buildLogoUpload(onboardNotifier),
            const SizedBox(height: 30),
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
          "Let’s help you list your services. Start by selecting a category and then describe the specific services you offer.",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  /// Single-select service chips with completed color
  Widget _buildServiceChips(OnboardNotifier onboardNotifier) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: onboardNotifier.serviceData.map((service) {
        final isSelected = onboardNotifier.selectedService == service;
        final isCompleted = onboardNotifier.isServiceCompleted(service);
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
            onboardNotifier.setSelectedService(service);
          },
        );
      }).toList(),
    );
  }

  /// Service details: Description + Image Upload + Done button
  Widget _buildServiceDetails(ServiceDropdownData service, OnboardNotifier onboardNotifier) {
    final controller = onboardNotifier.descriptionController;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: AppStyles.commonDecoration,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service.serviceName ?? "", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CustomTextField(
              controller: controller,
              isMaxLines: true,
              fieldName: "Description",
              titleVisibility: false,
              hintText: "Provide a brief overview of your ${onboardNotifier.selectedService?.serviceName ?? ""} service",
            ),
            const SizedBox(height: 8),
            _buildImageUpload(onboardNotifier, () {
              onboardNotifier.pickServiceImage();
            }, onboardNotifier.serviceImagePath),
            const SizedBox(height: 12),
            CustomButton(
              onPressed: onboardNotifier.doneWithService,
              backgroundColor: AppColors.white,
              borderColor: AppColors.primary,
              textStyle: AppFonts.text14.regular.style,
              text: "Done",
            )
          ],
        ),
      ),
    );
  }

  /// Image upload
  Widget _buildImageUpload(OnboardNotifier onboardNotifier, VoidCallback onUpload, String? imagePath) {
    return InkWell(
      onTap: onUpload,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        foregroundDecoration: DashedBorder(
          borderColor: Colors.grey.shade300,
        ),
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
          child: Image.file(
            onboardNotifier.getFileFromPath(imagePath),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  /// Logo upload
  Widget _buildLogoUpload(OnboardNotifier onboardNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Upload the Company Logo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildImageUpload(onboardNotifier, () {
          onboardNotifier.pickLogo();
        }, onboardNotifier.logoPath),
      ],
    );
  }

  /// Submit button
  Widget _buildSubmitButton(OnboardNotifier onboardNotifier) {
    return CustomButton(
      onPressed: onboardNotifier.submit,
      text: "Submit",
    );
  }
}
