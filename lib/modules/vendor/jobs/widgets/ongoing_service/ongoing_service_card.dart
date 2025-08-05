import 'package:community_app/core/model/vendor/jobs/ongoing_jobs_assigned_response.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/extensions.dart';
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
            10.verticalSpace,
            Text(job.serviceName ?? "Service Name", style: AppFonts.text14.medium.style),
            6.verticalSpace,
            Text("ID: ${job.jobId ?? '-'}", style: AppFonts.text12.regular.grey.style),
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
                Text("Dubai Marina, Tower A", style: AppFonts.text14.regular.style), // static if no location
              ],
            ),
            8.verticalSpace,
            _buildTimeAndEmployeeRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(job.customerName ?? "Customer Name", style: AppFonts.text16.semiBold.style),
        Text(job.customerRequestedDate?.formatDateTime() ?? '-', style: AppFonts.text12.regular.style),
      ],
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
        Text("Est. Time: 1:30 PM", style: AppFonts.text12.regular.grey.style), // static if no actual time
        Row(
          children: [
            CircleAvatar(
              radius: 10.r,
              backgroundColor: Colors.grey.shade300,
              child: Text(
                (employee?.employeeName?.isNotEmpty == true ? employee!.employeeName![0] : "A").toUpperCase(),
                style: AppFonts.text10.medium.white.style,
              ),
            ),
            6.horizontalSpace,
            Text(employee?.employeeName ?? "Ali Hassan", style: AppFonts.text12.regular.grey.style),
          ],
        )
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
