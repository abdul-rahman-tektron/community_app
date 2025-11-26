import 'dart:io';

import 'package:Xception/modules/vendor/registration/registration_notifier.dart';
import 'package:Xception/res/colors.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/res/images.dart';
import 'package:Xception/utils/extensions.dart';
import 'package:Xception/utils/helpers/file_upload_helper.dart';
import 'package:Xception/utils/helpers/screen_size.dart';
import 'package:Xception/utils/helpers/validations.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:Xception/utils/widgets/custom_buttons.dart';
import 'package:Xception/utils/widgets/custom_popup.dart';
import 'package:Xception/utils/widgets/custom_textfields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class VendorRegistrationTradingScreen extends StatelessWidget {
  const VendorRegistrationTradingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<VendorRegistrationNotifier>(
      builder: (context, vendorRegistrationNotifier, child) {
        return buildBody(context, vendorRegistrationNotifier);
      },
    );
  }

  Widget buildBody(BuildContext context, VendorRegistrationNotifier vendorRegistrationNotifier) {
    final addressKey = GlobalKey<FormState>();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: addressKey,
            child: Column(
              children: [
                // imageView(context),
                mainContent(context, addressKey, vendorRegistrationNotifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageView(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      width: ScreenSize.width,
      height: ScreenSize.height * 0.25,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.loginImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
        ),
      ),
      child: Stack(children: [_buildLogo(), _buildBackButton(context), _buildBottomText(context)]),
    );
  }

  Widget _buildLogo() {
    return Align(
      alignment: Alignment.topLeft,
      child: Image.asset(width: 100.w, AppImages.logo, fit: BoxFit.contain),
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
          ),
          child: Icon(LucideIcons.arrowLeft),
        ),
      ),
    );
  }

  Widget _buildBottomText(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.locale.welcomeToCommunityApp, style: AppFonts.text20.semiBold.white.style),
          10.verticalSpace,
          Text(context.locale.connectingResidents, style: AppFonts.text16.regular.white.style),
        ],
      ),
    );
  }

  Widget mainContent(BuildContext context, GlobalKey<FormState> addressKey, VendorRegistrationNotifier vendorRegistrationNotifier) {
    // Use the notifier directly since state is inside it


    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Trading Details", style: AppFonts.text24.semiBold.style),
          20.verticalSpace,
          CustomTextField(
            controller: vendorRegistrationNotifier.tradeLicenseIdController,
            fieldName: "Trade License number",
            keyboardType: TextInputType.number,
            validator: (value) => Validations.validateTradeLicense(context, value),
          ),
          15.verticalSpace,
          CustomTextField(
            controller: vendorRegistrationNotifier.tradeLicenseExpiryDateController,
            fieldName: "Trade License Expiry Date",
            keyboardType: TextInputType.datetime,
            initialDate: DateTime.now(),
            validator: (value) => Validations.validateTradeLicenseExpiry(context, value),
          ),
          15.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  vendorRegistrationNotifier.uploadedLicenseFile != null
                      ? vendorRegistrationNotifier.uploadedFileName ?? ""
                      : 'No file selected',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CustomUploadButton(
                text: "Upload",
                backgroundColor: AppColors.background,
                icon: LucideIcons.paperclip,
                textStyle: AppFonts.text14.regular.style,
                onPressed: () {
                  uploadImageWithDialog(context, vendorRegistrationNotifier);
                },
              ),
            ],
          ),
          40.verticalSpace,
          CustomButton(
            text: context.locale.next,
            onPressed: () {
              if(addressKey.currentState!.validate()) {
                vendorRegistrationNotifier.nextStep();
              }
            },
          ),
          15.verticalSpace,
          _alreadyHaveAnAccount(context),
        ],
      ),
    );
  }

  Future<void> uploadImageWithDialog(BuildContext context, VendorRegistrationNotifier registrationNotifier) async {
    showImageSourceDialog(context, (file) {
      registrationNotifier.uploadedLicenseFile = file;

      registrationNotifier.uploadedFileName = file.path.split('/').last;

      print(file.path.split('/').last);
      print(registrationNotifier.uploadedFileName);
      print("registrationNotifier.uploadedFileName");
      registrationNotifier.notifyListeners();
    });
  }

  Widget _alreadyHaveAnAccount(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "Already have an account? ",
        style: AppFonts.text16.regular.black.style,
        children: [
          TextSpan(
            text: "Sign in",
            style: AppFonts.text16.semiBold.black.style,
            recognizer: TapGestureRecognizer()..onTap = () {
              Navigator.of(rootNavigator: true, context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class IconOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const IconOption({super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Icon(icon, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
