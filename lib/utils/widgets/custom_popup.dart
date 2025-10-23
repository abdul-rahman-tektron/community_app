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

typedef BookingConfirmCallback = Future<void> Function(String isoDate, String? note);

void bookingConfirmationPopup(
    BuildContext context, {
      required BookingConfirmCallback onConfirm,
    }) {
  final _dateCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final today = DateTime.now();

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
          child: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Booking Confirmation", style: AppFonts.text20.semiBold.style),
                    16.verticalSpace,
                    Text(
                      "Select your preferred Date of Visit and optionally add a note.",
                      textAlign: TextAlign.center,
                      style: AppFonts.text14.regular.style,
                    ),
                    16.verticalSpace,

                    // DATE (dd/MM/yyyy) — launches your themed date/time pickers
                    CustomTextField(
                      controller: _dateCtrl,
                      fieldName: "Date of Visit",
                      hintText: "dd/MM/yyyy",
                      keyboardType: TextInputType.datetime,   // triggers _selectDate()
                      startDate: DateTime(today.year, today.month, today.day),
                      endDate: today.add(const Duration(days: 365)),
                      initialDate: today,
                      needTime: false,                         // date only
                      isAutoValidate: false,
                      validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "Please select a Date of Visit" : null,
                    ),

                    12.verticalSpace,

                    // NOTES (optional)
                    CustomTextField(
                      controller: _noteCtrl,
                      fieldName: "Notes (optional)",
                      hintText: "Any special instructions for the vendor…",
                      isMaxLines: true,
                      skipValidation: true,
                      isAutoValidate: false,
                    ),

                    18.verticalSpace,
                    Text(
                      "Once confirmed, the vendor will be notified and further changes may not be possible.",
                      textAlign: TextAlign.center,
                      style: AppFonts.text12.regular.style,
                    ),

                    16.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          fullWidth: false,
                          height: 40,
                          text: "Book Service",
                          textStyle: AppFonts.text14.regular.white.style,
                          onPressed: () async {
                            if (!(_formKey.currentState?.validate() ?? false)) return;

                            // Convert dd/MM/yyyy -> yyyy-MM-dd for API
                            final isoDate = _dateCtrl.text.toIsoDateFromDdMmYyyy();
                            final note = _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim();

                            Navigator.pop(context);
                            await onConfirm(isoDate, note);
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
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
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

void showSiteVisitRequestPopup(
    BuildContext context, {
      required Future<String?> Function(
          DateTime date,
          String employeeName,
          String phone,
          String emiratesId,
          ) onSubmit,
    }) {
  final formKey = GlobalKey<FormState>();

  final TextEditingController employeeNameController = TextEditingController();
  final TextEditingController employeePhoneNumberController = TextEditingController();
  final TextEditingController employeeEmiratesIdNumberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  String? _required(String? v, {String label = 'This field'}) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    return null;
  }

  bool _isValidUaeMobile(String input) {
    // Accepts: 05XXXXXXXX, +9715XXXXXXXX, 009715XXXXXXXX
    final pattern = RegExp(RegexPatterns.phone);
    return pattern.hasMatch(input.replaceAll(' ', ''));
  }

  String? _validateUaeMobile(String? v) {
    final base = _required(v, label: 'Employee Mobile Number');
    if (base != null) return base;
    return _isValidUaeMobile(v!.trim()) ? null : 'Enter a valid UAE mobile';
  }

  // Emirates ID formats:
  // 784-YYYY-NNNNNNN-N  or digits only (15 digits starting with 784)
  bool _isValidEmiratesIdBasic(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length != 15) return false;
    if (!cleaned.startsWith('784')) return false;
    return true; // (basic check; checksum can be added if needed)
  }

  String? _validateEmiratesId(String? v) {
    final base = _required(v, label: 'Employee Emirates ID Number');
    if (base != null) return base;
    return _isValidEmiratesIdBasic(v!) ? null : 'Enter a valid Emirates ID';
  }

  DateTime? _parseDdMmYyyy(String text) {
    try {
      return text.toDateTimeFromDdMmYyyy();
    } catch (_) {
      return null;
    }
  }

  String? _validateDate(String? v) {
    final base = _required(v, label: 'Preferred Date');
    if (base != null) return base;
    final dt = _parseDdMmYyyy(v!.trim());
    if (dt == null) return 'Use valid date format (DD/MM/YYYY)';
    final today = DateTime.now();
    final dtOnly = DateTime(dt.year, dt.month, dt.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    if (dtOnly.isBefore(todayOnly)) return 'Date cannot be in the past';
    return null;
  }

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
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Site Visit Request", style: AppFonts.text20.semiBold.style),
                      GestureDetector(
                        onTap: () => Navigator.pop(popupContext),
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  20.verticalSpace,

                  Text("Please provide details for your site visit request.", style: AppFonts.text14.regular.style),
                  15.verticalSpace,

                  CustomTextField(
                    controller: dateController,
                    fieldName: "Preferred Date",
                    keyboardType: TextInputType.datetime,
                    startDate: DateTime.now(),
                    initialDate: DateTime.now(),
                    validator: _validateDate,
                  ),
                  15.verticalSpace,

                  CustomTextField(
                    controller: employeeNameController,
                    fieldName: "Employee Name",
                    validator: (v) {
                      final base = _required(v, label: 'Employee Name');
                      if (base != null) return base;
                      if ((v ?? '').trim().length < 2) return 'Name looks too short';
                      return null;
                    },
                  ),
                  15.verticalSpace,

                  CustomTextField(
                    controller: employeePhoneNumberController,
                    fieldName: "Employee Mobile Number",
                    keyboardType: TextInputType.phone,
                    validator: _validateUaeMobile,
                  ),
                  15.verticalSpace,

                  CustomTextField(
                    controller: employeeEmiratesIdNumberController,
                    fieldName: "Employee Emirates ID Number",
                    keyboardType: TextInputType.number,
                    validator: _validateEmiratesId,
                  ),
                  20.verticalSpace,

                  CustomButton(
                    text: "Submit Request",
                    isLoading: loading,
                    onPressed: () async {
                      // Prevent double taps while loading
                      if (isLoading.value) return;

                      // Validate before submit
                      final isValid = formKey.currentState?.validate() ?? false;
                      if (!isValid) {
                        return;
                      }

                      isLoading.value = true;
                      try {
                        final date = _parseDdMmYyyy(dateController.text)!;

                        final result = await onSubmit(
                          date,
                          employeeNameController.text.trim(),
                          employeePhoneNumberController.text.trim(),
                          employeeEmiratesIdNumberController.text.trim(),
                        );

                        if (result != null && result.isNotEmpty) {
                          Navigator.pop(popupContext);
                          // ToastHelper.showSuccess(result);
                        } else {
                          ToastHelper.showError("Failed to submit request");
                        }
                      } catch (e) {
                        ToastHelper.showError("Something went wrong. Please try again.");
                        debugPrint("[SiteVisitPopup] Submit error: $e");
                      } finally {
                        isLoading.value = false;
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}


Future<void> showStatusNotesPopup(
    BuildContext context,
    {required Future<void> Function(String notes) onSubmit}
    ) async {
  final TextEditingController notesController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

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
              Text('Kindly provide a reason', style: AppFonts.text18.bold.style),
              20.verticalSpace,
              CustomTextField(controller: notesController, fieldName: "Reason", isMaxLines: true,),
              10.verticalSpace,
              CustomButton(text: "Submit", onPressed: () async {
                isLoading.value = true;

                await onSubmit(
                  notesController.text,
                );

                isLoading.value = false;

                Navigator.pop(ctx);
              }),
            ],
          ),
        ),
      );
    },
  );
}
