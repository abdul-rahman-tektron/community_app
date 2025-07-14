import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class ServiceRequestConfirmationScreen extends StatelessWidget {
  final String serviceId;

  const ServiceRequestConfirmationScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimation(),
            25.verticalSpace,
            _buildThankYouMessage(),
            10.verticalSpace,
            _buildSuccessMessage(),
            15.verticalSpace,
            _buildServiceIdBox(serviceId),
            15.verticalSpace,
            _buildInfoText(),
            50.verticalSpace,
            _buildViewVendorsButton(context),
          ],
        ),
      ),
    );
  }

  /// Animation (Lottie)
  Widget _buildAnimation() {
    return Lottie.asset(AppImages.planningGif, height: 250);
  }

  /// "Thank You!" Heading
  Widget _buildThankYouMessage() {
    return Text(
      'Thank You!',
      style: AppFonts.text24.semiBold.style,
    );
  }

  /// Service request confirmation message
  Widget _buildSuccessMessage() {
    return Text(
      'Your service request has been submitted successfully.',
      style: AppFonts.text16.regular.style,
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
          Text('Service ID: ', style: AppFonts.text16.regular.style,),
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
          'We’re already working behind the scenes to find the best vendor for your request.',
          style: AppFonts.text16.regular.style,
          textAlign: TextAlign.center,
        ),
        15.verticalSpace,
        Text(
          'This won’t take long. Get ready for top-rated options tailored for your needs!',
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
        Navigator.pushNamed(context, AppRoutes.topVendors);
      },
      text: 'View Top Vendors',
    );
  }
}
