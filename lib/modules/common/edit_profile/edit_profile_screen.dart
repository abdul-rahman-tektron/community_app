import 'dart:convert';

import 'package:Xception/core/model/customer/map/map_data.dart';
import 'package:Xception/modules/common/edit_profile/edit_profile_notifier.dart';
import 'package:Xception/res/colors.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/res/images.dart';
import 'package:Xception/utils/helpers/loader.dart';
import 'package:Xception/utils/helpers/validations.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:Xception/utils/widgets/custom_app_bar.dart';
import 'package:Xception/utils/widgets/custom_buttons.dart';
import 'package:Xception/utils/widgets/custom_drawer.dart';
import 'package:Xception/utils/widgets/custom_popup.dart';
import 'package:Xception/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditProfileNotifier(context),
      child: Consumer<EditProfileNotifier>(
        builder: (context, editProfileNotifier, child) {
          return LoadingOverlay<EditProfileNotifier>(
            child: buildBody(context, editProfileNotifier),
          );
        },
      ),
    );
  }

  buildBody(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.w),
          child: Column(
            children: [
              titleWidget(context, editProfileNotifier),
              15.verticalSpace,
              imageWidget(context, editProfileNotifier),
              15.verticalSpace,
              fullNameTextField(context, editProfileNotifier),
              15.verticalSpace,
              mobileNumberTextField(context, editProfileNotifier),
              15.verticalSpace,
              emailAddressTextField(context, editProfileNotifier),
              15.verticalSpace,
              addressTextField(context, editProfileNotifier),
              15.verticalSpace,
              buildingTextField(context, editProfileNotifier),
              15.verticalSpace,
              blockTextField(context, editProfileNotifier),
              25.verticalSpace,
              saveButton(context, editProfileNotifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleWidget(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return Text("Edit Profile", style: AppFonts.text20.regular.style);
  }

  Widget imageWidget(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 2),
            borderRadius: BorderRadius.circular(100.h),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.h),
            child: editProfileNotifier.uploadedUserProfile != null
                ? Image.file(
                    editProfileNotifier.uploadedUserProfile!,
                    height: 120.h,
                    width: 120.h,
                    fit: BoxFit.cover,
                  )
                : editProfileNotifier.userData?.image != null
                ? Image.memory(
                    base64Decode(editProfileNotifier.userData?.image ?? ""),
                    height: 120.h,
                    width: 120.h,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    AppImages.userPlaceHolder,
                    height: 120.h,
                    width: 120.h,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: InkWell(
            onTap: () {
              uploadImageWithDialog(context, editProfileNotifier);
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(100.h),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.h),
                child: Icon(LucideIcons.userRoundPen, size: 25, color: AppColors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> uploadImageWithDialog(
    BuildContext context,
    EditProfileNotifier editProfileNotifier,
  ) async {
    showImageSourceDialog(context, (file) {
      editProfileNotifier.uploadedUserProfile = file;

      editProfileNotifier.uploadedProfileName = file.path.split('/').last;

      print(file.path.split('/').last);
      print(editProfileNotifier.uploadedProfileName);
      print("editProfileNotifier.uploadedFileName");
      editProfileNotifier.notifyListeners();
    });
  }

  Widget fullNameTextField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.fullNameController,
      fieldName: "Full Name",
      isSmallFieldFont: true,
      keyboardType: TextInputType.name,
      validator: (value) => Validations.validateName(context, value),
    );
  }

  Widget mobileNumberTextField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.mobileNumberController,
      fieldName: "Mobile Number",
      isSmallFieldFont: true,
      keyboardType: TextInputType.phone,
    );
  }

  Widget emailAddressTextField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.emailAddressController,
      fieldName: "Email Address",
      isSmallFieldFont: true,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => Validations.validateEmail(context, value),
    );
  }

  Widget addressTextField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: CustomTextField(
            controller: editProfileNotifier.addressController,
            fieldName: "Address",
            showAsterisk: true,
            validator: (value) => Validations.validateAddress(context, value),
          ),
        ),
        10.horizontalSpace,
        InkWell(
          onTap: () async {
            final result = await Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(AppRoutes.mapLocation);
            if (result != null && result is MapData) {
              editProfileNotifier.addressController.text = result.address;
              editProfileNotifier.buildingController.text = result.building;
              editProfileNotifier.blockController.text = result.block;
              editProfileNotifier.setLatLng(result.latitude, result.longitude);
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
        ),
      ],
    );
  }

  Widget buildingTextField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.buildingController,
      fieldName: "Building",
      showAsterisk: true,
      validator: (value) => Validations.validateBuilding(context, value),
    );
  }

  Widget blockTextField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.blockController,
      fieldName: "Block",
      showAsterisk: true,
      validator: (value) => Validations.validateBlock(context, value),
    );
  }

  Widget saveButton(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomButton(text: "Save", onPressed: () => editProfileNotifier.saveData(context));
  }
}
