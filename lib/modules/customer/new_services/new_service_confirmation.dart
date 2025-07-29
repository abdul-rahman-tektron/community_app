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
    return Text('Request sent successfully', style: AppFonts.text24.semiBold.style);
  }

  /// Service request confirmation message
  Widget _buildSuccessMessage() {
    return Text(
      'Your Job request has been submitted to the selected vendors.',
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
          Text('Request ID: ', style: AppFonts.text16.regular.style),
          Text(id, style: AppFonts.text16.semiBold.blue.style),
        ],
      ),
    );
  }

  /// Additional Info Text
  Widget _buildInfoText() {
    return Column(
      children: [
        Text(
          'We are now collecting the best quotations for your request. This may take a short while.',
          style: AppFonts.text16.regular.style,
          textAlign: TextAlign.center,
        ),
        15.verticalSpace,
        Text(
          'You will be notified as soon as vendors respond.',
          style: AppFonts.text16.regular.style,
          textAlign: TextAlign.center,
        ),
        25.verticalSpace,
        Text.rich(
          TextSpan(
            text: 'You can monitor the progress anytime from the ',
            style: AppFonts.text16.regular.style,
            children: [
              TextSpan(
                text: 'Dashboard',
                style: AppFonts.text16.bold.red.style,
              ),
              const TextSpan(text: ' section.'),
            ],
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  /// Call-to-action Button
  Widget _buildViewVendorsButton(BuildContext context) {
    return CustomButton(
      onPressed: () {

        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.customerBottomBar, (route) => false, arguments: {'currentIndex': 0},);
      },
      text: 'Back To Dashboard',
    );
  }
}
