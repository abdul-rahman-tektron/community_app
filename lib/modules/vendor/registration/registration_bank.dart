import 'package:community_app/modules/vendor/registration/registration_notifier.dart';
import 'package:community_app/res/colors.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class VendorRegistrationBankScreen extends StatelessWidget {
  const VendorRegistrationBankScreen({
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

  Widget mainContent(BuildContext context, GlobalKey<FormState> addressKey, VendorRegistrationNotifier vendorRegistrationNotifier) {
    // Use the notifier directly since state is inside it


    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Bank Details", style: AppFonts.text24.semiBold.style),
          20.verticalSpace,
          CustomTextField(
            controller: vendorRegistrationNotifier.bankNameController,
            fieldName: "Bank Name",
            validator: (value) => Validations.validateBank(context, value),
          ),
          15.verticalSpace,
          CustomTextField(
            controller: vendorRegistrationNotifier.branchNameController,
            fieldName: "Branch",
            validator: (value) => Validations.validateBranch(context, value),
          ),
          15.verticalSpace,
          CustomTextField(
            controller: vendorRegistrationNotifier.accountNumberController,
            fieldName: "Account Number",
            validator: (value) => Validations.validateAccountNumber(context, value),
          ),
          15.verticalSpace,
          CustomTextField(
            controller: vendorRegistrationNotifier.iBanNumberController,
            fieldName: "iBan Number",
            validator: (value) => Validations.validateIBanNumber(context, value),
          ),
          40.verticalSpace,
          privacyPolicyWidget(context, vendorRegistrationNotifier),
          15.verticalSpace,
          CustomButton(
            text: "Sign up",
            onPressed: () {
              if(addressKey.currentState!.validate()) {
                vendorRegistrationNotifier.performRegistration(context);
              }
            },
          ),
          15.verticalSpace,
          _alreadyHaveAnAccount(context),
        ],
      ),
    );
  }

  Widget privacyPolicyWidget(BuildContext context, VendorRegistrationNotifier vendorRegistrationNotifier) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        vendorRegistrationNotifier.togglePrivacyPolicy();
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
                color: vendorRegistrationNotifier.acceptedPrivacyPolicy ? AppColors.white : Colors.transparent,
              ),
              child: vendorRegistrationNotifier.acceptedPrivacyPolicy
                  ? Icon(LucideIcons.check, size: 17, color: Colors.black)
                  : null,
            ),
            12.horizontalSpace,
            Expanded(child: Text("By creating this accounts means you agree to the Terms and Conditions, and our Privacy Policy", style: AppFonts.text14.regular.style)),
          ],
        ),
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
            recognizer: TapGestureRecognizer()..onTap = () {
              Navigator.of(rootNavigator: true, context).pop();
            },
          ),
        ],
      ),
    );
  }
}
