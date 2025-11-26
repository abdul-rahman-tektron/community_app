import 'package:Xception/core/model/vendor/jobs/ongoing_jobs_assigned_response.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/res/styles.dart';
import 'package:Xception/utils/extensions.dart';
import 'package:Xception/utils/helpers/common_utils.dart';
import 'package:Xception/utils/widgets/custom_linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class OngoingServiceCard extends StatelessWidget {
  final OngoingJobsAssignedData job;
  final VoidCallback? onViewDetails;

  const OngoingServiceCard({
    super.key,
    required this.job,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewDetails ?? () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: AppStyles.commonDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopRow(),
            8.verticalSpace,
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xffe7f3f9),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(
                    LucideIcons.mapPin,
                    color: Colors.blue,
                    size: 16,
                  ),
                ),
                6.horizontalSpace,
                Text(job.address ?? '-', style: AppFonts.text14.regular.style), // static if no location
              ],
            ),
            10.verticalSpace,
            _buildProgressBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.customerName ?? "Customer Name", style: AppFonts.text16.semiBold.style),
            5.verticalSpace,
            Text(job.serviceName ?? "Service Name", style: AppFonts.text14.medium.style),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(job.customerRequestedDate?.formatDate() ?? '-', style: AppFonts.text12.regular.style),
            5.verticalSpace,
            Text("#${job.jobId ?? '-'}", style: AppFonts.text12.regular.grey.style),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    // If you want to use estimatedAmount or progress (you need to decide)
    return Row(
      children: [
        _buildIconBox(),
        10.horizontalSpace,
        Expanded(
          child: Column(
            children: [
              _buildTimeAndEmployeeRow(),
              5.verticalSpace,
              CustomLinearProgressIndicator(
                percentage: AppStatus.fromName(job.status ?? "")?.percentage ?? 0, // Static or customize as needed
                borderRadius: 6,
              ),
            ],
          ),
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
        size: 22,
      ),
    );
  }

  Widget _buildProgressRow() {
    final color = _getProgressColor(job.jobStatusCategory ?? "Submitted");
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        job.jobStatusCategory ?? "Submitted",
        style: AppFonts.text14.medium.style.copyWith(color: color),
      ),
    );
  }

  Widget _buildTimeAndEmployeeRow() {
    final employee = job.assignedEmployees?.isNotEmpty == true ? job.assignedEmployees!.first : null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(AppStatus
            .fromName(job.status ?? "")
            ?.name ?? "", style: AppFonts.text12.regular.grey.style,
          ),
        ),
      ],
    );
  }

  Color _getProgressColor(String status) {
    switch (status.toLowerCase()) {
      case "submitted":
        return Colors.orange;
      case "started":
        return Colors.blue;
      case "in progress":
        return Colors.purple;
      case "completed":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
