import 'dart:io';

import 'package:community_app/core/model/common/error/error_response.dart';
import 'package:community_app/core/model/common/password/send_otp_request.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/modules/vendor/registration/registration_trading.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/file_upload_helper.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/regex.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void bookingConfirmationPopup(
  BuildContext context, {
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.textPrimary.withOpacity(0.4),
    builder: (_) => Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: AppStyles.commonDecoration,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Booking Confirmation",
                style: AppFonts.text20.semiBold.style,
              ),
              20.verticalSpace,
              Text(
                "Are you sure you want to proceed with the booking?",
                textAlign: TextAlign.center,
                style: AppFonts.text14.regular.style,
              ),
              10.verticalSpace,
              Text(
                "Once confirmed, the vendor will be notified and further changes may not be possible.",
                textAlign: TextAlign.center,
                style: AppFonts.text14.regular.style,
              ),
              15.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    fullWidth: false,
                    height: 40,
                    text: "Book Service",
                    textStyle: AppFonts.text14.regular.white.style,
                    onPressed: () {
                      Navigator.pop(context); // close popup first
                      onConfirm(); // trigger booking logic
                    },
                  ),
                  10.horizontalSpace,
                  CustomButton(
                    fullWidth: false,
                    height: 40,
                    backgroundColor: AppColors.white,
                    borderColor: AppColors.primary,
                    textStyle: AppFonts.text14.regular.style,
                    text: "Cancel",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
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
              Text('Select Image Source', style: AppFonts.text18.bold.style),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconOption(
                    icon: LucideIcons.camera,
                    label: 'Camera',
                    onTap: () async {
                      Navigator.pop(ctx);
                      final file = await FileUploadHelper.pickImage(
                        fromCamera: true,
                      );
                      if (file != null) onPicked(file);
                    },
                  ),
                  IconOption(
                    icon: LucideIcons.image,
                    label: 'Gallery',
                    onTap: () async {
                      Navigator.pop(ctx);
                      final file = await FileUploadHelper.pickImage(
                        fromCamera: false,
                      );
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

void showForgotPasswordPopup(BuildContext context) {
  final TextEditingController emailController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.primary.withOpacity(0.4),
    builder: (popupContext) => Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (_, loading, __) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Forget Password",
                      style: AppFonts.text20.semiBold.style,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(popupContext),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                30.verticalSpace,
                Text(
                  "We’ll send a verification code to your email to reset your password.",
                  style: AppFonts.text14.regular.grey.style,
                  textAlign: TextAlign.center,
                ),
                15.verticalSpace,
                CustomTextField(
                  controller: emailController,
                  fieldName: "Email",
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Submit",
                  isLoading: loading,
                  onPressed: () async {
                    if (emailController.text.trim().isEmpty) {
                      ToastHelper.showError("Email is required");
                      return;
                    }

                    if (!RegExp(
                      RegexPatterns.email,
                    ).hasMatch(emailController.text)) {
                      ToastHelper.showError("Please enter a valid email");
                      return;
                    }

                    isLoading.value = true;
                    final response = await CommonRepository.instance
                        .apiForgetPassword(
                          SendOtpRequest(email: emailController.text),
                        );

                    isLoading.value = false;
                    if (response == "OTP sent to your email.") {
                      Navigator.pop(popupContext);
                      Navigator.pushNamed(
                        context,
                        AppRoutes.otpVerification,
                        arguments: emailController.text,
                      );
                    } else if (response is ErrorResponse) {
                      ToastHelper.showError("Invalid email");
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

void showSiteVisitRequestPopup(BuildContext context, {
  required Future<String?> Function(DateTime date, String remarks) onSubmit,
}) {
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.primary.withOpacity(0.4),
    builder: (popupContext) => Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (_, loading, __) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Site Visit Request",
                      style: AppFonts.text20.semiBold.style,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(popupContext),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                20.verticalSpace,

                /// Message
                Text(
                  "Please provide the reason for your site visit request.",
                  style: AppFonts.text14.regular.style,
                ),
                15.verticalSpace,

                /// Preferred Date Input
                CustomTextField(
                  controller: dateController,
                  fieldName: "Preferred Date for Site Visit",
                  keyboardType: TextInputType.datetime,
                  startDate: DateTime.now(),
                  initialDate: DateTime.now(),
                ),
                15.verticalSpace,

                /// Remarks Input
                CustomTextField(
                  controller: remarksController,
                  fieldName: "Reason",
                  isMaxLines: true,
                ),
                20.verticalSpace,

                /// Submit Button
                CustomButton(
                  text: "Submit Request",
                  isLoading: loading,
                  onPressed: () async {
                    if (remarksController.text.trim().isEmpty) {
                      ToastHelper.showError("Remarks are required");
                      return;
                    }

                    isLoading.value = true;
                    final result = await onSubmit(dateController.text.toDateTimeFromDdMmYyyy(), remarksController.text.trim());
                    isLoading.value = false;

                    if (result != null && result.isNotEmpty) {
                      Navigator.pop(popupContext);
                      ToastHelper.showSuccess(result);
                    } else {
                      ToastHelper.showError("Failed to submit request");
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}