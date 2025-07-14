import 'package:community_app/modules/customer/edit_profile/edit_profile_notifier.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/utils/helpers/loader.dart';
import 'package:community_app/utils/helpers/validations.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_drawer.dart';
import 'package:community_app/utils/widgets/custom_search_dropdown.dart';
import 'package:community_app/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              fullNameTextField(context, editProfileNotifier),
              15.verticalSpace,
              mobileNumberTextField(context, editProfileNotifier),
              15.verticalSpace,
              emailAddressTextField(context, editProfileNotifier),
              15.verticalSpace,
              saveButton(context, editProfileNotifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleWidget(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return Text(
      "Edit Profile",
      style: AppFonts.text20.regular.style,
    );
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
      isEnable: false,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => Validations.validateEmail(context, value),
    );
  }


  Widget saveButton(BuildContext context,
      EditProfileNotifier editProfileNotifier) {
    return CustomButton(
      text: "Save",
      onPressed: () => editProfileNotifier.saveData(context),
    );
  }
}
