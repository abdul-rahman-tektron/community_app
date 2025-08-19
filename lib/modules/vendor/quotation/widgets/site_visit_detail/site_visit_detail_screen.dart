import 'package:community_app/modules/vendor/jobs/widgets/ongoing_service/progress_update/assign_bottom_sheet.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/helpers/dashed_border_container.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'site_visit_detail_notifier.dart';

class SiteVisitDetailScreen extends StatelessWidget {
  final String? requestId;
  const SiteVisitDetailScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SiteVisitDetailNotifier(requestId)..loadDetails(),
      child: Consumer<SiteVisitDetailNotifier>(
        builder: (context, notifier, _) {
          if (notifier.isLoading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          return Scaffold(
            appBar: CustomAppBar(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildJobDescription(context, notifier),
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
                          ? () => notifier.submitAssignedEmployees()
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
                  onPressed: () => notifier.declineRequest(),
                ),
              ),
            ],
          );
        },
      ),
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
            onAdd: (name, phone, {emiratesId}) => notifier.addEmployee(name, phone, emiratesId: emiratesId),
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
  Widget _buildJobDescription(BuildContext context, SiteVisitDetailNotifier notifier) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      width: double.infinity,
      decoration: AppStyles.commonDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ahmed Al Mazroui", style: AppFonts.text16.semiBold.style),
          5.verticalSpace,
          Text("Painting", style: AppFonts.text14.regular.style),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.phone,
            label: "05576263567",
            bgColor: Color(0xffeff7ef),
            iconColor: Colors.green,
          ),
          5.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.mapPin,
            label: "Jumeirah, Villa 23",
            bgColor: Color(0xffe7f3f9),
            iconColor: Colors.blue,
          ),
          5.verticalSpace,
          Text("Requested Date: 3 July 2025", style: AppFonts.text14.regular.style),
          10.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Priority: ', style: AppFonts.text14.regular.style),
                TextSpan(
                  text: 'Emergency',
                  style: AppFonts.text14.regular.red.style, // You can change the style here if needed
                ),
              ],
            ),
          ),
          10.verticalSpace,
          Image.asset(AppImages.loginImage, height: 100, width: 100, fit: BoxFit.cover),
          10.verticalSpace,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Job Description: ",
                  style: AppFonts.text14.semiBold.style, // Bold for "Remarks:"
                ),
                TextSpan(
                  text:
                  "We’re planning to repaint three bedrooms. One of them has old wallpaper that needs to be removed first. The other two just need surface preparation and a fresh coat of paint. We’d like durable, washable paint since we have young kids. Colors will be provided once the quote is finalized.",
                  style: AppFonts.text14.regular.style, // Regular for content
                ),
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
