import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void bookingConfirmationPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.textPrimary.withOpacity(0.4),
    builder: (_) => Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: AppStyles.commonDecoration,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Booking Confirmation", style: AppFonts.text20.semiBold.style),
              20.verticalSpace,
              Text("Are you sure you want to proceed with booking this service?" , textAlign: TextAlign.center, style:  AppFonts.text14.regular.style,),
              10.verticalSpace,
              Text("Once confirmed, the vendor will be notified and further changes may not be possible." , textAlign: TextAlign.center, style:  AppFonts.text14.regular.style,),
              15.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    fullWidth: false,
                    height: 40,
                    text: "Book Service",
                    textStyle: AppFonts.text14.regular.white.style,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.bookingConfirmation, arguments: "987638A567");
                    },
                  ),
                  10.horizontalSpace,
                  CustomButton(
                    fullWidth: false,
                    height: 40,
                    backgroundColor: AppColors.white,
                    borderColor: AppColors.primary,
                    textStyle: AppFonts.text14.regular.style,
                    text: "Cancel",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}