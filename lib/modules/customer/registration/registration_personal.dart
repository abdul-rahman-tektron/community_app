import 'package:Xception/modules/customer/registration/registration_notifier.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/res/images.dart';
import 'package:Xception/utils/extensions.dart';
import 'package:Xception/utils/helpers/screen_size.dart';
import 'package:Xception/utils/helpers/validations.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:Xception/utils/widgets/custom_buttons.dart';
import 'package:Xception/utils/widgets/custom_textfields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class CustomerRegistrationPersonalScreen extends StatelessWidget {
  CustomerRegistrationPersonalScreen({super.key});

  final _personalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerRegistrationNotifier>(
      builder: (context, customerRegistrationNotifier, child) {
        return buildBody(context, customerRegistrationNotifier);
      },
    );
  }

  Widget buildBody(BuildContext context, CustomerRegistrationNotifier customerChangeNotifier) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _personalKey,
            child: Column(children: [
              // _buildImageHeader(context),
              _buildFormSection(context, customerChangeNotifier)]),
          ),
        ),
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context) {
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
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset(AppImages.logo, width: 100.w, fit: BoxFit.contain),
          ),
          Align(alignment: Alignment.bottomLeft, child: _buildHeaderText(context)),
          _buildBackButton(context),
        ],
      ),
    );
  }
  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () {
          Navigator.of(rootNavigator: true, context).pop();
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

  Widget _buildHeaderText(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.locale.welcomeToCommunityApp, style: AppFonts.text20.semiBold.white.style),
        10.verticalSpace,
        Text(context.locale.connectingResidents, style: AppFonts.text16.regular.white.style),
      ],
    );
  }

  Widget _buildFormSection(BuildContext context, CustomerRegistrationNotifier customerChangeNotifier) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTitleSection(),
          20.verticalSpace,
          _buildFormFields(context, customerChangeNotifier),
          40.verticalSpace,
          CustomButton(
            text: context.locale.next,
            onPressed: () {
              if (_personalKey.currentState!.validate()) {
                customerChangeNotifier.nextStep();
              }
            },
          ),
          15.verticalSpace,
          _alreadyHaveAnAccount(context),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        Text("Create Your Account", style: AppFonts.text24.semiBold.style),
        5.verticalSpace,
        Text("One account, endless possibilities.", textAlign: TextAlign.center, style: AppFonts.text16.regular.style),
      ],
    );
  }

  Widget _buildFormFields(BuildContext context, CustomerRegistrationNotifier customerChangeNotifier) {
    return Column(
      children: [
        CustomTextField(
          controller: customerChangeNotifier.nameController,
          fieldName: context.locale.fullName,
          showAsterisk: true,
          validator: (value) => Validations.validateName(context, value),
        ),
        15.verticalSpace,
        CustomTextField(
          controller: customerChangeNotifier.emailController,
          fieldName: context.locale.email,
          showAsterisk: true,
          validator: (value) => Validations.validateEmail(context, value),
        ),
        15.verticalSpace,
        CustomTextField(
          controller: customerChangeNotifier.userIdController,
          fieldName: "User ID",
          showAsterisk: true,
          validator: (value) => Validations.validateUserID(context, value),
        ),
        15.verticalSpace,
        CustomTextField(
          controller: customerChangeNotifier.mobileController,
          fieldName: context.locale.mobileNumber,
          showAsterisk: true,
          keyboardType: TextInputType.phone,
          validator: (value) => Validations.validateMobile(context, value),
        ),
        // 15.verticalSpace,
        // CustomTextField(
        //   controller: customerChangeNotifier.passwordController,
        //   fieldName: context.locale.password,
        //   showAsterisk: true,
        //   isPassword: true,
        //   validator: (value) => Validations.validatePassword(context, value),
        // ),
      ],
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
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).pop();
              },
          ),
        ],
      ),
    );
  }
}
