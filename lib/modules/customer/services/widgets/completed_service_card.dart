import 'package:community_app/core/model/customer/job/ongoing_jobs_response.dart';
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

class CompletedServiceCard extends StatelessWidget {
  final CustomerOngoingJobsData service;

  const CompletedServiceCard({super.key, required this.service});

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
          10.verticalSpace,
          _buildProgressRow(),
          10.verticalSpace,
          _buildCheckProgressButton(context),
          20.verticalSpace,
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildServiceId() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: "Job ID: ", style: AppFonts.text16.regular.style),
          TextSpan(text: "#${service.jobId ?? '-'}", style: AppFonts.text16.regular.style),
        ],
      ),
    );
  }

  Widget _buildProgressRow() {
    final progress = service.jobStatusCategory ?? 'N/A';

    return Row(
      children: [
        _buildIconBox(),
        SizedBox(width: 10.w),
        _buildProgressText(progress),
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
      child: const Icon(LucideIcons.check, color: Colors.green, size: 20),
    );
  }

  Widget _buildCheckProgressButton(BuildContext context) {
    return CustomButton(
      text: "Check Progress",
      backgroundColor: AppColors.white,
      borderColor: AppColors.primary,
      textStyle: AppFonts.text14.regular.style,
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.jobVerification);
      },
      height: 35,
    );
  }

  Widget _buildProgressText(String progress) {
    return Text(progress, style: AppFonts.text14.regular.style);
  }

  Widget _buildProgressBar() {
    // No progressPercent in CustomerOngoingJobsData, set static or 100 since it's completed
    final progressPercent = 100.0;

    return CustomLinearProgressIndicator(percentage: progressPercent);
  }
}
