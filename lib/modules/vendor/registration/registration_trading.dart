import 'dart:io';

import 'package:community_app/core/model/map/map_data.dart';
import 'package:community_app/modules/customer/registration/registration_notifier.dart';
import 'package:community_app/modules/vendor/registration/registration_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/file_upload_helper.dart';
import 'package:community_app/utils/helpers/screen_size.dart';
import 'package:community_app/utils/helpers/validations.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_search_dropdown.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class VendorRegistrationTradingScreen extends StatelessWidget {
  final VendorRegistrationNotifier registrationNotifier;
  const VendorRegistrationTradingScreen({
    super.key,
    required this.registrationNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    final addressKey = GlobalKey<FormState>();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: addressKey,
            child: Column(
              children: [
                imageView(context),
                mainContent(context, addressKey),
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
      child: Stack(children: [_buildLogo(), _buildBottomText(context)]),
    );
  }

  Widget _buildLogo() {
    return Align(
      alignment: Alignment.topLeft,
      child: Image.asset(width: 100.w, AppImages.tektronLogo, fit: BoxFit.contain),
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

  Widget mainContent(BuildContext context, GlobalKey<FormState> addressKey) {
    // Use the notifier directly since state is inside it


    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Trading Details", style: AppFonts.text24.semiBold.style),
          20.verticalSpace,
          CustomTextField(
            controller: registrationNotifier.tradeLicenseIdController,
            fieldName: "Trade License number",
            validator: (value) => Validations.validateName(context, value),
          ),
          15.verticalSpace,
          CustomTextField(
            controller: registrationNotifier.tradeLicenseExpiryDateController,
            fieldName: "Trade License Expiry Date",
            keyboardType: TextInputType.datetime,
            initialDate: DateTime.now(),
          ),
          15.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  registrationNotifier.uploadedLicenseFile != null
                      ? registrationNotifier.uploadedFileName ?? ""
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
                  uploadImageWithDialog(context, registrationNotifier);
                },
              ),
            ],
          ),
          40.verticalSpace,
          CustomButton(
            text: context.locale.next,
            onPressed: () {
              if(addressKey.currentState!.validate()) {
                Navigator.pushNamed(context, AppRoutes.vendorRegistrationBank);
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

  Future<void> showImageSourceDialog(
      BuildContext context,
      Function(File file) onPicked,
      ) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Image Source',
                  style: AppFonts.text18.bold.style,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconOption(
                      icon: LucideIcons.camera,
                      label: 'Camera',
                      onTap: () async {
                        Navigator.pop(ctx);
                        final file = await FileUploadHelper.pickImage(fromCamera: true);
                        if (file != null) onPicked(file);
                      },
                    ),
                    IconOption(
                      icon: LucideIcons.image,
                      label: 'Gallery',
                      onTap: () async {
                        Navigator.pop(ctx);
                        final file = await FileUploadHelper.pickImage(fromCamera: false);
                        if (file != null) onPicked(file);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
              Navigator.of(context).pop();
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
