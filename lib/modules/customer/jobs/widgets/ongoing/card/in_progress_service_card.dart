import 'package:community_app/core/model/customer/job/ongoing_jobs_response.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:community_app/utils/widgets/custom_linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class InProgressServiceCard extends StatelessWidget {
  final CustomerOngoingJobsData service;

  const InProgressServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildServiceId(),
          10.verticalSpace,
          _buildTechnicianDetails(),
          20.verticalSpace,
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildServiceId() {
    return Row(
      children: [
        Expanded(child: Text(service.serviceName ?? "", style: AppFonts.text16.bold.style)),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: "#${service.jobId ?? 'N/A'}", style: AppFonts.text14.regular.style),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTechnicianDetails() {
    final assignedEmployee = (service.assignedEmployees?.isNotEmpty == true)
        ? service.assignedEmployees!.first
        : null;

    if (assignedEmployee == null) return const SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: _iconLabelRow(
            icon: LucideIcons.userRound,
            label: assignedEmployee.employeeName ?? 'Technician',
            bgColor: const Color(0xfffdf5e7),
            iconColor: Colors.orange,
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: _iconLabelRow(
            icon: LucideIcons.phone,
            label: assignedEmployee.employeePhoneNumber ?? '',
            bgColor: const Color(0xffe7f3f9),
            iconColor: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _iconLabelRow({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Row(
      children: [
        _iconBox(icon: icon, bgColor: bgColor, iconColor: iconColor),
        10.horizontalSpace,
        Expanded(
          child: Text(label, style: AppFonts.text14.regular.style),
        ),
      ],
    );
  }

  Widget _iconBox({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Icon(icon, color: iconColor, size: 20),
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

  Widget _buildProgressBar() {
    return Row(
      children: [
        _buildIconBox(),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(service.status ?? "", style: AppFonts.text14.regular.style),
              5.verticalSpace,
              CustomLinearProgressIndicator(
                percentage: AppStatus.fromName(service.status ?? "")?.percentage ?? 0, // Static or customize as needed
                borderRadius: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
