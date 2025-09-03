import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String bookingId;

  const BookingConfirmationScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: false,),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimation(),
                20.verticalSpace,
                _buildThankYouMessage(),
                15.verticalSpace,
                _buildDeliveryMessage(),
                15.verticalSpace,
                _buildServiceIdBox(bookingId),
                15.verticalSpace,
                _buildInfoText(),
                50.verticalSpace,
                _buildViewVendorsButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Animation (Lottie)
  Widget _buildAnimation() {
    return Lottie.asset(AppImages.bookingGif, height: 250, width: 250, fit: BoxFit.cover);
  }

  /// "Thank You!" Heading
  Widget _buildThankYouMessage() {
    return Text(
      'Thank You for Booking!',
      style: AppFonts.text24.semiBold.style,
    );
  }

  /// Service request confirmation message
  Widget _buildDeliveryMessage() {
    return Text.rich(
      TextSpan(
        text: 'Estimated service time by ',
        style: AppFonts.text16.regular.style,
        children: [
          TextSpan(
            text: 'Mon, April 5th',
            style: AppFonts.text16.semiBold.style,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Service ID Display Box
  Widget _buildServiceIdBox(String id) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Booking ID: ', style: AppFonts.text16.regular.style,),
          Text(
            id,
            style: AppFonts.text16.semiBold.blue.style,
          ),
        ],
      ),
    );
  }

  /// Additional Info Text
  Widget _buildInfoText() {
    return Column(
      children: [
        Text(
          'You will receive an email at ',
          style: AppFonts.text16.regular.style,
          textAlign: TextAlign.center,
        ),
        Text(
          'jondoe@mymail.com',
          style: AppFonts.text16.bold.style,
          textAlign: TextAlign.center,
        ),
        15.verticalSpace,
        Text(
          'To change or cancel booking go to Booking History',
          style: AppFonts.text16.regular.style,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Call-to-action Button
  Widget _buildViewVendorsButton(BuildContext context) {
    return CustomButton(
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.customerBottomBar, (route) => false ,arguments: {'currentIndex': 0},);
      },
      text: 'Back to Services',
    );
  }
}
