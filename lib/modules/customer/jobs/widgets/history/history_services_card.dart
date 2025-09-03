import 'package:community_app/core/model/customer/job/customer_history_list_response.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:community_app/utils/extensions.dart';

class HistoryServiceCard extends StatelessWidget {
  final CustomerHistoryListData service;

  const HistoryServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(12),
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(),
          2.verticalSpace,
          Text(service.serviceName ?? "", style: AppFonts.text14.regular.style),
          10.verticalSpace,
          _buildDateTimeRow(),
          15.verticalSpace,
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        Expanded(child: _buildCustomerName()),
        Text("#${service.jobId ?? 'N/A'}", style: AppFonts.text14.regular.style),
      ],
    );
  }

  Widget _buildCustomerName() {
    return Text(service.vendorName ?? "", style: AppFonts.text16.regular.style);
  }

  Widget _buildDateTimeRow() {
    final date = service.requestedDate?.formatDate() ?? 'N/A';
    final time = service.requestedDate?.formatTime() ?? 'N/A';

    return Row(
      children: [
        Expanded(
          child: _iconLabelRow(
            icon: LucideIcons.calendar,
            label: date,
            bgColor: const Color(0xfffdf5e7),
            iconColor: Colors.orange,
          ),
        ),
        Expanded(
          child: _iconLabelRow(
            icon: LucideIcons.clock,
            label: time,
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
        Expanded(child: Text(label, style: AppFonts.text14.regular.style)),
      ],
    );
  }

  Widget _iconBox({required IconData icon, required Color bgColor, required Color iconColor}) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: "View Details",
            height: 35,
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.previousDetails,
                arguments: {
                  "jobId": service.jobId ?? "",
                  "vendorId": service.vendorId ?? "",
                  "vendorName": service.vendorName ?? "",
                  "serviceName": service.serviceName ?? "",
                },
              );
            },
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: CustomButton(
            text: "Book Again",
            height: 35,
            backgroundColor: AppColors.white,
            borderColor: AppColors.primary,
            textStyle: AppFonts.text14.regular.style,
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.newServices,
                arguments: {
                  "vendorId": service.vendorId ?? "",
                  "vendorName": service.vendorName ?? "",
                  "serviceName": service.serviceName ?? "",
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
