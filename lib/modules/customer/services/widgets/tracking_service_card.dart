import 'package:community_app/core/model/customer/job/ongoing_jobs_response.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_linear_progress_indicator.dart';

class TrackingServiceCard extends StatelessWidget {
  final CustomerOngoingJobsData job;

  const TrackingServiceCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final arrival = job.customerRequestedDate?.toLocal().formatDateTime(withTime: true) ?? 'N/A';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      padding: EdgeInsets.all(15.w),
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildJobId(),
          SizedBox(height: 15.h),
          _buildTrackingRow(context, arrival),
          SizedBox(height: 15.h),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildJobId() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: "Job ID: ", style: AppFonts.text16.regular.style),
          TextSpan(text: "#${job.jobId ?? 'N/A'}", style: AppFonts.text16.regular.style),
        ],
      ),
    );
  }

  Widget _buildTrackingRow(BuildContext context, String arrival) {
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
            Navigator.pushNamed(context, AppRoutes.tracking, arguments: job.jobId);
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
        color: const Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Icon(
        LucideIcons.clockFading,
        color: Colors.grey,
        size: 20,
      ),
    );
  }

  Widget _buildArrivalText(String arrival) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Estimated Arrival:", style: AppFonts.text14.regular.style),
        SizedBox(height: 4.h),
        Text(arrival, style: AppFonts.text14.regular.style),
      ],
    );
  }

  Widget _buildProgressBar() {
    // If you want to use estimatedAmount or progress (you need to decide)
    print("job.status");
    print(job.status);
    return CustomLinearProgressIndicator(
      percentage: AppStatus.fromName(job.status ?? "")?.percentage ?? 0, // Static or customize as needed
      borderRadius: 6,
    );
  }
}
