import 'package:community_app/modules/auth/reset_password/reset_password_notifier.dart';
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

class ResetPasswordScreen extends StatelessWidget {
  final String? email;
  final String? otp;
  const ResetPasswordScreen({super.key, this.email, this.otp});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ResetPasswordNotifier(email, otp),
      child: Consumer<ResetPasswordNotifier>(
        builder: (context, notifier, child) {
          return buildBody(context, notifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, ResetPasswordNotifier notifier) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.w),
          child: Form(
            key: notifier.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerWidget(context),
                20.verticalSpace,
                newPasswordTextField(context, notifier),
                5.verticalSpace,
                Align(
                  alignment: Alignment.centerRight,
                  child: PasswordStrengthStars(password: notifier.newPasswordController.text),
                ),
                15.verticalSpace,
                confirmPasswordTextField(context, notifier),
                30.verticalSpace,
                saveButton(context, notifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headerWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reset Password",
          style: AppFonts.text24.regular.style,
        ),
        10.verticalSpace,
        Text(
          "Enter and confirm your new password to complete the reset process.",
          style: AppFonts.text14.regular.style,
        ),
      ],
    );
  }

  Widget newPasswordTextField(BuildContext context, ResetPasswordNotifier notifier) {
    return CustomTextField(
      controller: notifier.newPasswordController,
      fieldName: "New Password",
      isSmallFieldFont: true,
      isPassword: true,
      validator: (value) => Validations.validatePassword(context, value),
    );
  }

  Widget confirmPasswordTextField(BuildContext context, ResetPasswordNotifier notifier) {
    return CustomTextField(
      controller: notifier.confirmPasswordController,
      fieldName: "Confirm Password",
      isSmallFieldFont: true,
      isPassword: true,
      validator: (value) => Validations.validateConfirmPassword(
        context,
        notifier.newPasswordController.text,
        notifier.confirmPasswordController.text,
      ),
    );
  }

  Widget saveButton(BuildContext context, ResetPasswordNotifier notifier) {
    return CustomButton(
      onPressed: () => notifier.savePassword(context),
      height: 45,
      isLoading: notifier.loadingState == LoadingState.busy,
      text: "Save Password",
    );
  }
}
