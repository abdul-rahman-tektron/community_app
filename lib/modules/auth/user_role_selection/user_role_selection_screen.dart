import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/notifier/language_notifier.dart';
import 'package:community_app/modules/auth/user_role_selection/user_role_selection_notifier.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/screen_size.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserRoleSelectionScreen extends ConsumerWidget {
  const UserRoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRoleSelectionNotifier = ref.watch(userRoleSelectionNotifierProvider);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [imageView(context, ref), 20.verticalSpace, mainContent(context, ref)]),
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
    return Padding(
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(context.locale.pleaseChooseYourRole, style: AppFonts.text20.semiBold.style),
          10.verticalSpace,
          Text(context.locale.yourRoleHelpsUs, textAlign: TextAlign.center, style: AppFonts.text16.regular.style),
          30.verticalSpace,
          CustomButton(
            text: context.locale.tenant,
            onPressed: () {
              ref.read(baseNotifierProvider.notifier).userRole = UserRole.tenant;
              ref.watch(userRoleSelectionNotifierProvider.notifier).selectRoleAndNavigate(context, UserRole.tenant);
            },
          ),
          20.verticalSpace,
          CustomButton(
            text: context.locale.owner,
            onPressed: () {
              ref.read(baseNotifierProvider.notifier).userRole = UserRole.owner;
              ref.watch(userRoleSelectionNotifierProvider.notifier).selectRoleAndNavigate(context, UserRole.owner);
            },
          ),
          20.verticalSpace,
          CustomButton(
            text: context.locale.vendor,
            onPressed: () {
              ref.read(baseNotifierProvider.notifier).userRole = UserRole.vendor;
              ref.watch(userRoleSelectionNotifierProvider.notifier).selectRoleAndNavigate(context, UserRole.vendor);
            },
          ),
          20.verticalSpace,
          languageWidget(context, ref),
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
