import 'package:community_app/core/model/map/map_data.dart';
import 'package:community_app/modules/customer/registration/registration_notifier.dart';
import 'package:community_app/modules/vendor/registration/registration_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/utils/extensions.dart';
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

class VendorRegistrationAddressScreen extends StatelessWidget {
  final VendorRegistrationNotifier registrationNotifier;
  const VendorRegistrationAddressScreen({
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
          Text("Address Details", style: AppFonts.text24.semiBold.style),
          20.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CustomTextField(
                  controller: registrationNotifier.addressController,
                  fieldName: "Address",
                  showAsterisk: true,
                  validator: (value) => Validations.validateName(context, value),
                ),
              ),
              10.horizontalSpace,
              InkWell(
                onTap: () async {
                  final result = await Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.mapLocation);
                  if (result != null && result is MapData) {
                    registrationNotifier.addressController.text = result.address;
                    registrationNotifier.buildingController.text = result.building;
                    registrationNotifier.blockController.text = result.block;
                    registrationNotifier.setLatLng(result.latitude, result.longitude);
                  }
                },
                child: Container(
                  height: 45.h,
                  width: 45.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(LucideIcons.mapPin, color: AppColors.white, size: 20.sp),
                ),
              )
            ],
          ),
          15.verticalSpace,
          CustomTextField(
            controller: registrationNotifier.buildingController,
            fieldName: "Building",
            showAsterisk: true,
          ),
          15.verticalSpace,
          CustomTextField(
            controller: registrationNotifier.blockController,
            fieldName: "Block",
            showAsterisk: true,
          ),
          40.verticalSpace,
          CustomButton(
            text: context.locale.next,
            onPressed: () {
              if(addressKey.currentState!.validate()) {
                Navigator.of(context).pushNamed(AppRoutes.vendorRegistrationTrading);
              }
            },
          ),
          15.verticalSpace,
          _alreadyHaveAnAccount(context),
        ],
      ),
    );
  }

  Widget privacyPolicyWidget(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        registrationNotifier.togglePrivacyPolicy();
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
                color: registrationNotifier.acceptedPrivacyPolicy ? AppColors.white : Colors.transparent,
              ),
              child: registrationNotifier.acceptedPrivacyPolicy
                  ? Icon(LucideIcons.check, size: 17, color: Colors.black)
                  : null,
            ),
            12.horizontalSpace,
            Text(context.locale.rememberMe, style: AppFonts.text14.regular.style),
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
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
