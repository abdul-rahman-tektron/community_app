import 'package:community_app/modules/customer/delete_account/delete_account_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/helpers/validations.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_drawer.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DeleteAccountNotifier(),
      child: Consumer<DeleteAccountNotifier>(
        builder: (context, deleteAccountNotifier, child) {
          return buildBody(context, deleteAccountNotifier);
        },
      ),
    );
  }

  Widget buildBody(
    BuildContext context,
    DeleteAccountNotifier deleteAccountNotifier,
  ) {
    
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.w),
          child: Form(
            key: deleteAccountNotifier.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...contentWidget(context, deleteAccountNotifier),
                10.verticalSpace,
                emailAddressTextField(context, deleteAccountNotifier),
                15.verticalSpace,
                deleteAndCancelButtons(context, deleteAccountNotifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> contentWidget(BuildContext context, DeleteAccountNotifier deleteAccountNotifier) {
    return [
      Text(
        "Delete Account",
        style: AppFonts.text24.regular.style,
      ),
      15.verticalSpace,
      Text(
        "Do you want to permanently delete your account?",
        style: AppFonts.text16.regular.style,
      ),
      10.verticalSpace,
      Text(
        "This action cannot be undone.",
        style: AppFonts.text16.regular.style,
      ),
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "This will permanently delete ",
              style: AppFonts.text16.regular.style,
            ),
            TextSpan(
              text: deleteAccountNotifier.userData?.email ?? "",
              style: AppFonts.text16.regular.red.style, // Change the color here
            ),
            TextSpan(
              text: " account",
              style: AppFonts.text16.regular.style,
            ),
          ],
        ),
      ),
      10.verticalSpace,
      Text(
        "Please type ${deleteAccountNotifier.userData?.email ?? ""} to confirm.",
        style: AppFonts.text16.regular.style,
      ),
    ];
  }

  Widget emailAddressTextField(
    BuildContext context,
    DeleteAccountNotifier deleteAccountNotifier,
  ) {
    return CustomTextField(
      controller: deleteAccountNotifier.emailAddressController,
      fieldName: "Email Address",
      isSmallFieldFont: true,
      validator: (value) => Validations.validateEmail(context, value),
    );
  }

  Widget deleteAndCancelButtons(BuildContext context,
      DeleteAccountNotifier deleteAccountNotifier,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomButton(
            text: "Delete Account",
            fullWidth: false,
            height: 45,
            backgroundColor: AppColors.error,
            isLoading: deleteAccountNotifier.loadingState == LoadingState.busy,
            onPressed: () {
              final formValid = deleteAccountNotifier.formKey.currentState!.validate();
              final enteredEmail = deleteAccountNotifier.emailAddressController.text;
              final userEmail = deleteAccountNotifier.userData?.email ?? "";

              if (!formValid) return;

              if (enteredEmail != userEmail) {
                ToastHelper.showError(
                  "Incorrect Email Format",
                );
                return;
              }

              deleteAccountNotifier.runWithLoadingVoid(() => deleteAccountNotifier.apiDeleteAccount(context));
            },
        ),
        10.horizontalSpace,
        CustomButton(text: "Cancel",
          backgroundColor: Colors.white,
          borderColor: AppColors.primary,
          textStyle: AppFonts.text14.regular.style,
          height: 45,
          fullWidth: false,
          onPressed: () {
            deleteAccountNotifier.emailAddressController.clear();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
