import 'package:community_app/modules/customer/services/services_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TrackingServiceCard extends StatelessWidget {
  final ServiceModel service;

  const TrackingServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.all(12),
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildServiceId(),
          SizedBox(height: 15.h),
          _buildTrackingRow(context),
          SizedBox(height: 15.h),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildServiceId() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "Service ID: ",
            style: AppFonts.text16.semiBold.style,
          ),
          TextSpan(
            text: "#${service.id}",
            style: AppFonts.text16.regular.style,
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingRow(BuildContext context) {
    final arrival = service.estimatedArrival?.toLocal().formatDateTime(withTime: true) ?? 'N/A';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              _buildIconBox(),
              SizedBox(width: 10.w),
              _buildArrivalText(arrival),
            ],
          ),
        ),
        CustomButton(
          height: 35.h,
          fullWidth: false,
          backgroundColor: AppColors.white,
          borderColor: AppColors.primary,
          textStyle: AppFonts.text14.regular.style,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.tracking);
          },
          text: "Track",
        ),
      ],
    );
  }

  Widget _buildIconBox() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xffeff7ef),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Icon(
        LucideIcons.clockFading,
        color: Colors.green,
        size: 20,
      ),
    );
  }

  Widget _buildArrivalText(String arrival) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Estimated Arrival:", style: AppFonts.text14.semiBold.style),
        SizedBox(height: 4.h),
        Text(arrival, style: AppFonts.text14.regular.style),
      ],
    );
  }

  Widget _buildProgressBar() {
    return CustomLinearProgressIndicator(
      percentage: service.progressPercent ?? 0,
    );
  }
}
