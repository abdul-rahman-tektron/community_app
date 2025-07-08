import 'package:community_app/modules/customer/services/services_notifier.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class InProgressServiceCard extends StatelessWidget {
  final ServiceModel service;

  const InProgressServiceCard({super.key, required this.service});

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
          _buildTechnicianDetails(),
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

  Widget _buildProgressRow() {
    return Row(
      children: [
        _iconBox(
          icon: LucideIcons.clockFading,
          bgColor: const Color(0xffeff7ef),
          iconColor: Colors.green,
        ),
        10.horizontalSpace,
        Expanded(
          child: Text(
            service.progressStatus ?? 'N/A',
            style: AppFonts.text14.regular.style,
          ),
        ),
      ],
    );
  }

  Widget _buildTechnicianDetails() {
    final technician = service.technician;

    if (technician == null) return const SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: _iconLabelRow(
            icon: LucideIcons.userRound,
            label: technician.name,
            bgColor: const Color(0xfffdf5e7),
            iconColor: Colors.orange,
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: _iconLabelRow(
            icon: LucideIcons.phone,
            label: technician.contact ?? '',
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

  Widget _buildProgressBar() {
    return CustomLinearProgressIndicator(
      percentage: service.progressPercent ?? 0,
    );
  }
}
