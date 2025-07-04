import 'package:community_app/core/notifier/language_notifier.dart';
import 'package:community_app/modules/customer/registration/registration_notifier.dart';
import 'package:community_app/modules/vendor/registration/registration_notifier.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/screen_size.dart';
import 'package:community_app/utils/helpers/validations.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class VendorRegistrationPersonalScreen extends ConsumerWidget {
  const VendorRegistrationPersonalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationNotifier = ref.watch(vendorRegistrationNotifierProvider);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: registrationNotifier.formKey,
            child: Column(
              children: [
                imageView(context, ref),
                30.verticalSpace,
                mainContent(context, ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageView(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(15.w),
      width: ScreenSize.width,
      height: ScreenSize.height * 0.35,
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
          20.verticalSpace,
        ],
      ),
    );
  }

  Widget mainContent(BuildContext context, WidgetRef ref) {
    final registrationNotifier = ref.watch(vendorRegistrationNotifierProvider);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      child: Column(
        children: [
          CustomTextField(
            controller: registrationNotifier.nameController,
            fieldName: context.locale.fullName,
            showAsterisk: true,
            validator: (value) => Validations.validateName(context, value),
          ),
          15.verticalSpace,
          CustomTextField(
            controller: registrationNotifier.emailController,
            fieldName: context.locale.email,
            showAsterisk: true,
            validator: (value) => Validations.validateEmail(context, value),
          ),
          15.verticalSpace,
          CustomTextField(
            controller: registrationNotifier.mobileController,
            fieldName: context.locale.mobileNumber,
            showAsterisk: true,
            keyboardType: TextInputType.phone,
            validator: (value) => Validations.validateMobile(context, value),
          ),
          CustomTextField(
            controller: registrationNotifier.mobile2Controller,
            fieldName: context.locale.mobileNumber,
            showAsterisk: true,
            keyboardType: TextInputType.phone,
            validator: (value) => Validations.validateMobile(context, value),
          ),
          15.verticalSpace,
          CustomTextField(
            controller: registrationNotifier.passwordController,
            fieldName: context.locale.password,
            showAsterisk: true,
            validator: (value) => Validations.validatePassword(context, value),
          ),
          40.verticalSpace,
          CustomButton(
            text: context.locale.next,
            onPressed: () {
              if (registrationNotifier.validateAndSave()) {
                // Navigate to next screen or call notifier method
                // Example:
                // context.pushNamed('OwnerVendorRegistrationAddress');
              }
            },
          ),
        ],
      ),
    );
  }
}
