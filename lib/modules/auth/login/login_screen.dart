import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:community_app/core/notifier/language_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/screen_size.dart';
import 'package:community_app/utils/helpers/validations.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:provider/provider.dart';
import 'login_notifier.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginNotifier(),
      child: Consumer<LoginNotifier>(
        builder: (context, loginNotifier, _) {
          return buildBody(context, loginNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, LoginNotifier loginNotifier) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: loginNotifier.formKey,
            child: Column(
              children: [
                imageView(context),
                30.verticalSpace,
                mainContent(context, loginNotifier),
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
      height: ScreenSize.height * 0.35,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.loginImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset(width: 100.w, AppImages.tektronLogo, fit: BoxFit.contain),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.locale.welcomeToCommunityApp, style: AppFonts.text20.semiBold.white.style),
                  10.verticalSpace,
                  Text(context.locale.connectingResidents, style: AppFonts.text16.regular.white.style),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mainContent(BuildContext context, LoginNotifier loginNotifier) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      child: Column(
        children: [
          CustomTextField(
            controller: loginNotifier.userNameController,
            fieldName: "User ID",
            showAsterisk: false,
            validator: (value) => Validations.validateUserID(context, value),
          ),
          15.verticalSpace,
          CustomTextField(
            controller: loginNotifier.passwordController,
            fieldName: context.locale.password,
            showAsterisk: false,
            isPassword: true,
            validator: (value) => Validations.validatePassword(context, value),
          ),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              rememberMeWidget(context, loginNotifier),
              forgetPasswordWidget(context, loginNotifier)
            ],
          ),
          30.verticalSpace,
          CustomButton(
            text: context.locale.login,
            onPressed: () => loginNotifier.performLogin(context),
          ),
          20.verticalSpace,
          Text.rich(
            TextSpan(
              text: "${context.locale.dontHaveAccount} ",
              style: AppFonts.text16.regular.black.style,
              children: [
                TextSpan(
                  text: context.locale.signUp,
                  style: AppFonts.text16.semiBold.black.style,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (loginNotifier.userRole == UserRole.vendor.name) {
                        Navigator.pushNamed(context, AppRoutes.vendorRegistrationHandler);
                      } else {
                        Navigator.pushNamed(context, AppRoutes.customerRegistrationHandler);
                      }
                    },
                ),
              ],
            ),
          ),
          10.verticalSpace,
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              text: context.locale.changeLanguageTo,
              style: AppFonts.text16.regular.style,
              children: [
                TextSpan(
                  text: " ${context.locale.switchLng}",
                  style: AppFonts.text16.regular.red.style,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      final langNotifier = context.read<LanguageNotifier>();
                      langNotifier.switchLanguage();
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget forgetPasswordWidget(BuildContext context, LoginNotifier loginNotifier) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: Text(context.locale.forgetPassword, style: AppFonts.text14.medium.style),
    );
  }

  Widget rememberMeWidget(BuildContext context, LoginNotifier loginNotifier) {
    return GestureDetector(
      onTap: () {
        loginNotifier.toggleRememberMe(!loginNotifier.isChecked);
      },
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 1.5),
              borderRadius: BorderRadius.circular(6),
              color: loginNotifier.isChecked ? AppColors.white : Colors.transparent,
            ),
            child: loginNotifier.isChecked
                ? Icon(LucideIcons.check, size: 17, color: Colors.black)
                : null,
          ),
          8.horizontalSpace,
          Text(context.locale.rememberMe, style: AppFonts.text14.regular.style),
        ],
      ),
    );
  }
}
