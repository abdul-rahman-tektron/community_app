import 'dart:convert';

import 'package:Xception/modules/vendor/jobs/widgets/ongoing_service/progress_update/assign_bottom_sheet.dart';
import 'package:Xception/res/colors.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/res/images.dart';
import 'package:Xception/res/styles.dart';
import 'package:Xception/utils/extensions.dart';
import 'package:Xception/utils/helpers/dashed_border_container.dart';
import 'package:Xception/utils/helpers/loader.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:Xception/utils/widgets/custom_app_bar.dart';
import 'package:Xception/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'site_visit_detail_notifier.dart';

class SiteVisitDetailScreen extends StatelessWidget {
  final String? jobId;
  final int? siteVisitId;
  final int? vendorId;
  final int? customerId;
  const SiteVisitDetailScreen({super.key, this.jobId, this.customerId, this.siteVisitId, this.vendorId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SiteVisitDetailNotifier(jobId, customerId, siteVisitId, vendorId),
      child: Consumer<SiteVisitDetailNotifier>(
        builder: (context, notifier, _) {
          return LoadingOverlay<SiteVisitDetailNotifier>(
            child: buildBody(context, notifier),
          );
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, SiteVisitDetailNotifier notifier) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCustomerInfo(context, notifier),
            10.verticalSpace,

            /// If employees are assigned → show list
            // Step 1: Assign Employee (Multiple)
            if (!notifier.isEmployeeAssigned) ...[
              _buildAssignEmployeeList(notifier),
              10.verticalSpace,
              _buildAddEmployeeButton(context, notifier),
              20.verticalSpace,
              CustomButton(
                text: "Submit Employees",
                onPressed: notifier.assignedEmployees.isNotEmpty
                    ? () => notifier.submitAssignedEmployees(context)
                    : null,
              ),
            ],

            /// If employee assigned but quotation not updated → show "Update Quotation"
            if (notifier.isEmployeeAssigned && !notifier.isQuotationUpdated) ...[
              Text("Assigned Employees", style: AppFonts.text16.semiBold.style),
              5.verticalSpace,
              _buildAssignEmployeeList(notifier),
              15.verticalSpace,
              CustomButton(
                text: "Update Quotation",
                onPressed: () => notifier.navigateToUpdateQuotation(context),
              ),
            ],

            /// If quotation updated → show a read-only confirmation
            if (notifier.isQuotationUpdated)
              ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: AppStyles.commonDecoration,
                  child: Column(
                    children: [
                      Icon(Icons.check_box, size: 50, color: Colors.green),
                      10.verticalSpace,
                      Text("Quotation has been submitted.", style: AppFonts.text16.regular.style),
                    ],
                  ),
                ),
                15.verticalSpace,
                CustomButton(
                  text: "Back to Home",
                  onPressed: () => notifier.navigateToHomeScreen(context),
                ),
              ]

          ],
        ),
      ),

      /// Persistent Decline Button
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: "Decline",
            backgroundColor: AppColors.error,
            onPressed: () => notifier.declineRequest(context),
          ),
        ),
      ],
    );
  }

  /// Employee List
  Widget _buildAssignEmployeeList(SiteVisitDetailNotifier notifier) {
    if (notifier.assignedEmployees.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: AppStyles.commonDecoration,
        child: Column(
          children: [
            Icon(Icons.no_accounts, size: 50),
            10.verticalSpace,
            Text("No employees added yet.", style: AppFonts.text16.regular.style),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: notifier.assignedEmployees.map((e) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: AppStyles.commonDecoration,
          child: ListTile(
            leading: Icon(LucideIcons.userRound),
            title: Text(e.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.phone),
                if (e.emiratesId != null)
                  GestureDetector(
                    onTap: () {
                      // Show full-screen viewer for Emirates ID
                      // Or use your existing image viewer
                    },
                    child: Text(
                      "View Emirates ID",
                      style: TextStyle(color: AppColors.primary, fontSize: 12),
                    ),
                  ),
              ],
            ),
            trailing: notifier.isEmployeeAssigned && !notifier.isQuotationUpdated ? null : GestureDetector(
              onTap: () => notifier.removeEmployee(e),
              child: Icon(LucideIcons.trash, color: Colors.red),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Add Employee Button
  Widget _buildAddEmployeeButton(BuildContext context, SiteVisitDetailNotifier notifier) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppColors.background,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => AssignBottomSheet(
            showEmiratesId: true, // 👈 added true here
            onAdd: (name, phone, emiratesIdNumber, {emiratesId}) =>
                notifier.addEmployee(name, phone, emiratesIdNumber: emiratesIdNumber, emiratesId: emiratesId),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        foregroundDecoration: DashedBorder(
          borderColor: AppColors.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.plus, size: 20, color: AppColors.primary),
            const SizedBox(width: 10),
            Text("Add Employee", style: AppFonts.text14.semiBold.style),
          ],
        ),
      ),
    );
  }

  /// Job Description Section
  Widget buildCustomerInfo(BuildContext context, SiteVisitDetailNotifier notifier) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
      width: double.infinity,
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notifier.jobDetail.customerName ?? "Customer Name", style: AppFonts.text16.semiBold.style),
          5.verticalSpace,
          Text(notifier.jobDetail.serviceName ?? "Service Name", style: AppFonts.text14.regular.style),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.phone,
            label: notifier.jobDetail.phoneNumber ?? "---",
            bgColor: const Color(0xffeff7ef),
            iconColor: Colors.green,
          ),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.mapPin,
            label: notifier.jobDetail.address ?? "---",
            bgColor: const Color(0xffe7f3f9),
            iconColor: Colors.blue,
          ),
          5.verticalSpace,
          Text("Requested Date: ${notifier.jobDetail.expectedDate?.formatFullDateTime() ?? "00/00/0000"}", style: AppFonts.text14.regular.style),
          10.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Priority: ', style: TextStyle(fontSize: 14)),
                TextSpan(
                  text: notifier.jobDetail.priority ?? "None",
                  style: AppFonts.text14.regular.red.style,
                ),
              ],
            ),
          ),
          10.verticalSpace,
          if (notifier.jobDetail.fileContent != null)
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, AppRoutes.imageViewer, arguments: notifier.jobDetail.fileContent);
              },
              child: Image.memory(
                base64Decode(notifier.jobDetail.fileContent ?? ""),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          10.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: "Job Description: ", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: notifier.jobDetail.remarks ?? "Not Added"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Icon with Label
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
}
