
import 'package:Xception/core/model/common/dropdown/community_dropdown_response.dart';
import 'package:Xception/core/model/customer/map/map_data.dart';
import 'package:Xception/modules/customer/registration/registration_notifier.dart';
import 'package:Xception/res/colors.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/res/images.dart';
import 'package:Xception/utils/extensions.dart';
import 'package:Xception/utils/helpers/screen_size.dart';
import 'package:Xception/utils/helpers/validations.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:Xception/utils/widgets/custom_buttons.dart';
import 'package:Xception/utils/widgets/custom_search_dropdown.dart';
import 'package:Xception/utils/widgets/custom_textfields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class CustomerRegistrationAddressScreen extends StatelessWidget {
  const CustomerRegistrationAddressScreen({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerRegistrationNotifier>(
      builder: (context, customerRegistrationNotifier, child) {
        return buildBody(context, customerRegistrationNotifier);
      },
    );
  }

  Widget buildBody(BuildContext context, CustomerRegistrationNotifier customerChangeNotifier) {
    final addressKey = GlobalKey<FormState>();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: addressKey,
            child: Column(
              children: [
                // imageView(context),
                mainContent(context, addressKey, customerChangeNotifier),
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

  Widget mainContent(BuildContext context, GlobalKey<FormState> addressKey, CustomerRegistrationNotifier customerChangeNotifier) {
    // Use the notifier directly since state is inside it


    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Address Details", style: AppFonts.text24.semiBold.style),
          20.verticalSpace,
          CustomSearchDropdown<CommunityDropdownData>(
            fieldName: "Community",
            hintText: "Enter Community",
            controller: customerChangeNotifier.communityController,
            items: customerChangeNotifier.communityDropdownData,
            currentLang: 'en', // You need to inject language if needed
            itemLabel: (item, lang) => item.name!, // Simplified for example
            onSelected: (CommunityDropdownData? menu) {
              customerChangeNotifier.setCommunity(menu);
            },
            validator: (value) => Validations.validateCommunity(context, value),
          ),
          15.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CustomTextField(
                  controller: customerChangeNotifier.addressController,
                  fieldName: "Address",
                  showAsterisk: true,
                  validator: (value) => Validations.validateAddress(context, value),
                  readOnly: true,
                  showCursor: false,
                  onTap: () async {
                    final result = await Navigator.of(context, rootNavigator: true)
                        .pushNamed(AppRoutes.mapLocation);

                    if (result is MapData) {
                      customerChangeNotifier.addressController.text = result.address;
                      customerChangeNotifier.buildingController.text = result.building;
                      customerChangeNotifier.blockController.text = result.block;
                      customerChangeNotifier.setLatLng(result.latitude, result.longitude);
                    }
                  },
                ),
              ),
              10.horizontalSpace,
              InkWell(
                onTap: () async {
                  final result = await Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.mapLocation);
                  if (result != null && result is MapData) {
                    customerChangeNotifier.addressController.text = result.address;
                    customerChangeNotifier.buildingController.text = result.building;
                    customerChangeNotifier.blockController.text = result.block;
                    customerChangeNotifier.setLatLng(result.latitude, result.longitude);
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
            controller: customerChangeNotifier.buildingController,
            fieldName: "Building",
            showAsterisk: true,
            validator: (value) => Validations.validateBuilding(context, value),
          ),
          15.verticalSpace,
          CustomTextField(
            controller: customerChangeNotifier.blockController,
            fieldName: "Block",
            showAsterisk: true,
            validator: (value) => Validations.validateBlock(context, value),
          ),
          40.verticalSpace,
          privacyPolicyWidget(context, customerChangeNotifier),
          10.verticalSpace,
          CustomButton(
            text: context.locale.signUp,
            onPressed: () {
              if(addressKey.currentState!.validate()) {
                customerChangeNotifier.performRegistration(context);
              }
            },
          ),
          15.verticalSpace,
          _alreadyHaveAnAccount(context),
        ],
      ),
    );
  }

  Widget privacyPolicyWidget(BuildContext context, CustomerRegistrationNotifier customerChangeNotifier) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        customerChangeNotifier.togglePrivacyPolicy();
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
                color: customerChangeNotifier.acceptedPrivacyPolicy ? AppColors.white : Colors.transparent,
              ),
              child: customerChangeNotifier.acceptedPrivacyPolicy
                  ? Icon(LucideIcons.check, size: 17, color: Colors.black)
                  : null,
            ),
            12.horizontalSpace,
            Expanded(
              child: Text(
                  "By creating this accounts means you agree to the Terms and Conditions, and our Privacy Policy",
                style: AppFonts.text14.regular.style,
              ),
            ),
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
