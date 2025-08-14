import 'package:community_app/modules/common/change_password/change_password_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/helpers/password_strength.dart';
import 'package:community_app/utils/helpers/validations.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_drawer.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChangePasswordNotifier(context),
      child: Consumer<ChangePasswordNotifier>(
        builder: (context, changePasswordNotifier, child) {
          return buildBody(context, changePasswordNotifier);
        },
      ),
    );
  }

  Widget buildBody(
      BuildContext context,
      ChangePasswordNotifier changePasswordNotifier,
      ) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.w),
          child: Form(
            key: changePasswordNotifier.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerWidget(context, changePasswordNotifier),
                15.verticalSpace,
                emailAddressTextField(context, changePasswordNotifier),
                15.verticalSpace,
                currentPasswordTextField(context, changePasswordNotifier),
                15.verticalSpace,
                newPasswordTextField(context, changePasswordNotifier),
                10.verticalSpace,
                Align(
                  alignment: Alignment.centerRight,
                  child: PasswordStrengthStars(password: changePasswordNotifier.newPasswordController.text),
                ),
                10.verticalSpace,
                confirmPasswordTextField(context, changePasswordNotifier),
                30.verticalSpace,
                saveButton(context, changePasswordNotifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headerWidget(
      BuildContext context,
      ChangePasswordNotifier changePasswordNotifier,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Change Password",
          style: AppFonts.text24.regular.style,
        ),
        10.verticalSpace,
        Text(
          "For better security, use a mix of upper/lowercase letters, numbers, and special characters in your new password.",
          style: AppFonts.text14.regular.style,),
      ],
    );
  }

  Widget emailAddressTextField(
      BuildContext context,
      ChangePasswordNotifier changePasswordNotifier,
      ) {
    return CustomTextField(
      controller: changePasswordNotifier.userIdController,
      fieldName: "User Id",
      isSmallFieldFont: true,
      isEnable: false,
      validator: (value) => Validations.validateUserID(context, value),
    );
  }

  Widget currentPasswordTextField(
      BuildContext context,
      ChangePasswordNotifier changePasswordNotifier,
      ) {
    return CustomTextField(
      controller: changePasswordNotifier.currentPasswordController,
      fieldName: "Current Password",
      isSmallFieldFont: true,
      isPassword: true,
      validator: (value) => Validations.validatePassword(context, value),
    );
  }

  Widget newPasswordTextField(
      BuildContext context,
      ChangePasswordNotifier changePasswordNotifier,
      ) {
    return CustomTextField(
      controller: changePasswordNotifier.newPasswordController,
      fieldName: "New Password",
      isSmallFieldFont: true,
      isPassword: true,
      validator: (value) => Validations.validatePassword(context, value),
    );
  }

  Widget confirmPasswordTextField(
      BuildContext context,
      ChangePasswordNotifier changePasswordNotifier,
      ) {
    return CustomTextField(
      controller: changePasswordNotifier.confirmPasswordController,
      fieldName: "Confirm Password",
      isSmallFieldFont: true,
      isPassword: true,
      validator: (value) =>
          Validations.validateConfirmPassword(
              context,
              changePasswordNotifier.newPasswordController.text,
              changePasswordNotifier.confirmPasswordController.text),
    );
  }

  Widget saveButton(
      BuildContext context,
      ChangePasswordNotifier changePasswordNotifier,
      ) {
    return CustomButton(
      onPressed: () => changePasswordNotifier.saveButtonFunctionality(context),
      height: 45,
      isLoading: changePasswordNotifier.loadingState == LoadingState.busy,
      text: "Save",
    );
  }
}
