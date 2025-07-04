import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/notifier/language_notifier.dart';
import 'package:community_app/modules/common/select_location_map.dart';
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
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'login_notifier.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginNotifier = ref.watch(loginNotifierProvider.notifier);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: loginNotifier.formKey,
            child: Column(children: [imageView(context, ref), 30.verticalSpace, mainContent(context, ref)]),
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
    final loginNotifier = ref.watch(loginNotifierProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _emailField(context, ref),
          15.verticalSpace,
          _passwordField(context, ref),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [rememberMeWidget(context, loginNotifier), forgetPasswordWidget(context, ref)],
          ),
          40.verticalSpace,
          _loginButton(context, ref),
          15.verticalSpace,
          _dontHaveAnAccount(context, ref),
          10.verticalSpace,
          languageWidget(context, ref),
        ],
      ),
    );
  }

  Widget _emailField(BuildContext context, WidgetRef ref) {
    final loginNotifier = ref.watch(loginNotifierProvider.notifier);
    return CustomTextField(
      controller: loginNotifier.emailController,
      fieldName: context.locale.emailOrPhone,
      showAsterisk: false,
      validator: (value) => Validations.validateEmail(context, value),
    );
  }

  Widget _passwordField(BuildContext context, WidgetRef ref) {
    final loginNotifier = ref.watch(loginNotifierProvider.notifier);
    return CustomTextField(
      controller: loginNotifier.passwordController,
      fieldName: context.locale.password,
      showAsterisk: false,
      isPassword: true,
      validator: (value) => Validations.validatePassword(context, value),
    );
  }

  Widget rememberMeWidget(BuildContext context, LoginNotifier loginNotifier) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        loginNotifier.toggleRememberMe(!loginNotifier.rememberMe);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 1.5),
                borderRadius: BorderRadius.circular(6),
                color: loginNotifier.rememberMe ? AppColors.white : Colors.transparent,
              ),
              child: loginNotifier.rememberMe ? Icon(LucideIcons.check, size: 17, color: Colors.black) : null,
            ),
            12.horizontalSpace,
            Text(context.locale.rememberMe, style: AppFonts.text14.regular.style),
          ],
        ),
      ),
    );
  }

  Widget forgetPasswordWidget(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: Text(context.locale.forgetPassword, style: AppFonts.text14.medium.style),
    );
  }

  Widget _loginButton(BuildContext context, WidgetRef ref) {
    final loginNotifier = ref.read(loginNotifierProvider.notifier);
    return CustomButton(
      text: context.locale.login,
      onPressed: () async {
        if (loginNotifier.validateAndSave()) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login success!')));
        }
      },
    );
  }

  Widget _dontHaveAnAccount(BuildContext context, WidgetRef ref) {
    return Text.rich(
      TextSpan(
        text: "${context.locale.dontHaveAccount} ",
        style: AppFonts.text16.regular.black.style,
        children: [
          TextSpan(
            text: context.locale.signUp,
            style: AppFonts.text16.semiBold.black.style,
            recognizer: TapGestureRecognizer()..onTap = () {
                if (ref.read(baseNotifierProvider).userRole == UserRole.tenant ||
                    ref.read(baseNotifierProvider).userRole == UserRole.owner) {
                  context.push(AppRoutes.ownerTenantRegistrationPersonal);
                } else if (ref.read(baseNotifierProvider).userRole == UserRole.vendor) {
                  context.push(AppRoutes.vendorRegistrationPersonal);
                }
              },
          ),
        ],
      ),
    );
  }

  Widget languageWidget(BuildContext context, WidgetRef ref) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: context.locale.changeLanguageTo,
        style: AppFonts.text16.regular.style,
        children: [
          TextSpan(text: " ", style: AppFonts.text16.regular.red.style),
          TextSpan(
            text: context.locale.switchLng,
            style: FontResolver.resolve(context.locale.switchLng, AppFonts.text16.regular.red.style),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                ref.read(languageNotifierProvider.notifier).switchLanguage();
              },
          ),
        ],
      ),
    );
  }
}
