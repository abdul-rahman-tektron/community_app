import 'package:Xception/modules/vendor/registration/registration_notifier.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/res/images.dart';
import 'package:Xception/utils/extensions.dart';
import 'package:Xception/utils/helpers/screen_size.dart';
import 'package:Xception/utils/helpers/validations.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:Xception/utils/widgets/custom_buttons.dart';
import 'package:Xception/utils/widgets/custom_textfields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class VendorRegistrationPersonalScreen extends StatelessWidget {
  const VendorRegistrationPersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VendorRegistrationNotifier>(
      builder: (context, vendorRegistrationNotifier, child) {
        return _buildBody(context, vendorRegistrationNotifier);
      },
    );
  }

  Widget _buildBody(BuildContext context, VendorRegistrationNotifier vendorRegistrationNotifier) {
    final personalKey = GlobalKey<FormState>();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: personalKey,
            child: Column(
              children: [
                // _imageView(context),
                _mainContent(context, personalKey, vendorRegistrationNotifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageView(BuildContext context) {
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

  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop();
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

  Widget _mainContent(
    BuildContext context,
    GlobalKey<FormState> personalKey,
    VendorRegistrationNotifier vendorRegistrationNotifier,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Create Your Account", style: AppFonts.text24.semiBold.style),
          5.verticalSpace,
          Text(
            "One account, endless possibilities.",
            textAlign: TextAlign.center,
            style: AppFonts.text16.regular.style,
          ),
          20.verticalSpace,
          CustomTextField(
            controller: vendorRegistrationNotifier.nameController,
            fieldName: context.locale.fullName,
            showAsterisk: true,
            validator: (value) => Validations.validateName(context, value),
          ),
          15.verticalSpace,
          CustomTextField(
            controller: vendorRegistrationNotifier.emailController,
            fieldName: context.locale.email,
            showAsterisk: true,
            validator: (value) => Validations.validateEmail(context, value),
          ),
          15.verticalSpace,
          CustomTextField(
            controller: vendorRegistrationNotifier.userIdController,
            fieldName: "User ID",
            showAsterisk: true,
            validator: (value) => Validations.validateUserID(context, value),
          ),
          15.verticalSpace,
          CustomTextField(
            controller: vendorRegistrationNotifier.contact1Controller,
            fieldName: "Contact Number 1",
            showAsterisk: true,
            keyboardType: TextInputType.phone,
            validator: (value) => Validations.validateContact1(context, value),
          ),
          15.verticalSpace,
          CustomTextField(
            controller: vendorRegistrationNotifier.contact2Controller,
            fieldName: "Contact Number 2",
            showAsterisk: true,
            keyboardType: TextInputType.phone,
            validator: (value) => Validations.validateContact2(context, value),
          ),
          15.verticalSpace,
          CustomTextField(
            controller: vendorRegistrationNotifier.passwordController,
            fieldName: context.locale.password,
            showAsterisk: true,
            isPassword: true,
            validator: (value) => Validations.validatePassword(context, value),
          ),
          40.verticalSpace,
          CustomButton(
            text: context.locale.next,
            onPressed: () {
              // Implement validation method in RegistrationNotifier if needed
              if (personalKey.currentState!.validate()) {
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

  Widget _alreadyHaveAnAccount(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "Already have an account? ",
        style: AppFonts.text16.regular.black.style,
        children: [
          TextSpan(
            text: "Sign in",
            style: AppFonts.text16.semiBold.black.style,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(rootNavigator: true, context).pop();
              },
          ),
        ],
      ),
    );
  }
}
