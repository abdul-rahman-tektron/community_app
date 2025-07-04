import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/notifier/language_notifier.dart';
import 'package:community_app/modules/customer/registration/registration_notifier.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/screen_size.dart';
import 'package:community_app/utils/helpers/validations.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';


class OwnerTenantRegistrationPersonalScreen extends ConsumerWidget {
  const OwnerTenantRegistrationPersonalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationNotifier = ref.read(ownerTenantRegistrationNotifierProvider.notifier);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: registrationNotifier.personalFormKey,
            child: Column(
              children: [
                imageView(context, ref),
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

  Widget mainContent(BuildContext context, WidgetRef ref) {
    final registrationNotifier = ref.watch(ownerTenantRegistrationNotifierProvider);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Create Your Account", style: AppFonts.text24.semiBold.style),
          5.verticalSpace,
          Text("One account, endless possibilities.", textAlign: TextAlign.center, style: AppFonts.text16.regular.style),
          20.verticalSpace,
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
          15.verticalSpace,
          CustomTextField(
            controller: registrationNotifier.passwordController,
            fieldName: context.locale.password,
            showAsterisk: true,
            isPassword: true,
            validator: (value) => Validations.validatePassword(context, value),
          ),
          40.verticalSpace,
          CustomButton(
            text: context.locale.next,
            onPressed: () {
              context.push(AppRoutes.ownerTenantRegistrationAddress);
              // if (registrationNotifier.validateAndSave()) {
              //   // Navigate to next screen or call notifier method
              //   // Example:
              //   // context.pushNamed('OwnerVendorRegistrationAddress');
              // }
            },
          ),
          15.verticalSpace,
          _alreadyHaveAnAccount(context, ref),
        ],
      ),
    );
  }

  Widget _alreadyHaveAnAccount(BuildContext context, WidgetRef ref) {
    return Text.rich(
      TextSpan(
        text: "Already have an account? ",
        style: AppFonts.text16.regular.black.style,
        children: [
          TextSpan(
            text: "Sign in",
            style: AppFonts.text16.semiBold.black.style,
            recognizer: TapGestureRecognizer()..onTap = () {
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
