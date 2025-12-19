import 'package:Xception/modules/auth/otp_verification/otp_verification_notifier.dart';
import 'package:Xception/modules/auth/register_verify/register_verify_notifier.dart';
import 'package:Xception/res/colors.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/res/images.dart';
import 'package:Xception/utils/widgets/custom_app_bar.dart';
import 'package:Xception/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class RegisterVerifyScreen extends StatelessWidget {
  final String? email;
  const RegisterVerifyScreen({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterVerifyNotifier(email),
      child: Consumer<RegisterVerifyNotifier>(
        builder: (context, registerVerifyNotifier, child) {
          return buildBody(context, registerVerifyNotifier);
        },
      ),
    );
  }

  Widget buildBody(
      BuildContext context,
      RegisterVerifyNotifier notifier,
      ) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppImages.otpVerificationImage, scale: 2.5,),
                  50.verticalSpace,
                  Text(
                    "Please Enter your Verification Code",
                    style: AppFonts.text20.semiBold.style,
                  ),
                  10.verticalSpace,
                  Text(
                    "We’ve sent a 6-digit code to your registered email Id.",
                    textAlign: TextAlign.center,
                    style: AppFonts.text16.regular.style,
                  ),
                  30.verticalSpace,

                  // OTP input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 50,
                        child: TextField(
                          controller: notifier.otpControllers[index],
                          focusNode: notifier.focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          onChanged: (value) {
                            notifier.onOtpChange(value, index);
                          },
                          decoration: InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                              ),
                              focusColor: AppColors.primary,
                              fillColor: AppColors.white
                          ),
                        ),
                      );
                    }),
                  ),

                  50.verticalSpace,

                  // Verify button
                  CustomButton(text: "Verify", onPressed: () => notifier.verifyOtp(context)),

                  10.verticalSpace,

                  // Resend section
                  notifier.isResendEnabled
                      ? TextButton(
                    onPressed: notifier.resendOtp,
                    child: Text("Resend Code", style: AppFonts.text16.regular.style),
                  )
                      : Text(
                    "Resend available in ${notifier.secondsRemaining}s",
                    style: AppFonts.text16.regular.style,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
