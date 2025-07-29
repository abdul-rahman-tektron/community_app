import 'package:community_app/modules/vendor/jobs/widgets/ongoing_service/ongoing_service_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class OngoingServiceCard extends StatelessWidget {
  final OngoingServiceModel job;
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
            Text(job.serviceName, style: AppFonts.text14.medium.style),
            6.verticalSpace,
            Text("ID: ${job.jobId}", style: AppFonts.text12.regular.grey.style),
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
                Text(job.location, style: AppFonts.text14.regular.style),
              ],
            ),
            8.verticalSpace,
            _buildTimeAndEmployeeRow(),
            // 12.verticalSpace,
            // _buildBottomRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(job.customerName, style: AppFonts.text16.semiBold.style),
        Text(job.date.formatDateTime(), style: AppFonts.text12.regular.style),
      ],
    );
  }

  Widget _buildProgressRow() {
    final color = _getProgressColor(job.progress);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // light background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        job.progress,
        style: AppFonts.text14.medium.style.copyWith(color: color),
      ),
    );
  }


  Widget _buildTimeAndEmployeeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Est. Time: ${job.estimatedTime}", style: AppFonts.text12.regular.grey.style),
        Row(
          children: [
            CircleAvatar(
              radius: 10.r,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: job.assignedEmployeeImage != null && job.assignedEmployeeImage!.isNotEmpty
                  ? NetworkImage(job.assignedEmployeeImage!)
                  : null,
              child: job.assignedEmployeeImage == null || job.assignedEmployeeImage!.isEmpty
                  ? Text(
                job.assignedEmployee.isNotEmpty ? job.assignedEmployee[0] : '',
                style: AppFonts.text10.medium.white.style,
              )
                  : null,
            ),
            6.horizontalSpace,
            Text(
              job.assignedEmployee,
              style: AppFonts.text12.regular.grey.style,
            ),
          ],
        )

      ],
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButton(
          text: "Update Status",
          height: 32.h,
          backgroundColor: AppColors.white,
          borderColor: AppColors.primary,
          textStyle: AppFonts.text14.regular.style,
          fullWidth: false,
          onPressed: onViewDetails ?? () {},
        ),
        _buildProgressRow()
      ],
    );
  }

  Color _getProgressColor(String status) {
    switch (status.toLowerCase()) {
      case "on the way":
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
