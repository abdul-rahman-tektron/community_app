import 'package:community_app/res/colors.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import 'package:community_app/modules/vendor/dashboard/dashboard_notifier.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';

class VendorDashboardScreen extends StatelessWidget {
  const VendorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VendorDashboardNotifier(),
      child: Consumer<VendorDashboardNotifier>(
        builder: (context, notifier, child) {
          return Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLicenseAlertCard(notifier),
                  15.verticalSpace,
                  _buildLicenseStatusCard(notifier),
                  25.verticalSpace,

                  Text("Quick Stats", style: AppFonts.text16.semiBold.style),
                  10.verticalSpace,
                  _buildQuickStatsGrid(notifier),
                  25.verticalSpace,

                  Text("Quick Actions", style: AppFonts.text16.semiBold.style),
                  10.verticalSpace,
                  buildQuickActions(context, notifier),
                  25.verticalSpace,

                  Text("Alerts", style: AppFonts.text16.semiBold.style),
                  _buildAlertsList(notifier),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLicenseAlertCard(VendorDashboardNotifier notifier) {
    final license = notifier.licenseStatus;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Color(0xffffe8e8),
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(
            color: Colors.red,
            width: 5.0,
          ),
        ),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 7)],
      ),
      child: Row(
        children: [
          Icon(LucideIcons.info, color: Colors.red, size: 25.w),
          15.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("License Expiring Soon", style: AppFonts.text14.bold.style),
                5.verticalSpace,
                Text(
                  "Your Trade License is expiring on ${license.expiryDate.toLocal().toString().split(' ')[0]}, Please renew your license",
                  style: AppFonts.text14.regular.style,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseStatusCard(VendorDashboardNotifier notifier) {
    final license = notifier.licenseStatus;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: Colors.orange, width: 5.0)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 7)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Trade License Status", style: AppFonts.text16.semiBold.style),
          10.verticalSpace,
          _buildKeyValueRow("License ID", license.licenseId),
          5.verticalSpace,
          _buildKeyValueRow("Expiry Date", license.expiryDate.toLocal().toString().split(' ')[0]),
          5.verticalSpace,
          _buildKeyValueRow("Status", license.status, valueColor: Colors.green),
        ],
      ),
    );
  }

  Widget _buildKeyValueRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppFonts.text14.regular.style),
        Flexible(
          child: Text(
            value,
            style: AppFonts.text14.regular.style.copyWith(color: valueColor ?? AppColors.textPrimary),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsGrid(VendorDashboardNotifier notifier) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: notifier.quickStats.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 1,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemBuilder: (context, index) {
        final stat = notifier.quickStats[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: AppStyles.commonDecoration,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(color: stat.iconBgColor, borderRadius: BorderRadius.circular(8.r)),
                child: Icon(stat.icon, color: stat.iconColor, size: 20.w),
              ),
              15.horizontalSpace,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stat.count.toString(), style: AppFonts.text18.semiBold.style, overflow: TextOverflow.ellipsis),
                    2.verticalSpace,
                    Text(stat.label, style: AppFonts.text14.regular.style),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildQuickActions(BuildContext context, VendorDashboardNotifier notifier) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: notifier.quickActions.length,
      itemBuilder: (context, index) {
        final action = notifier.quickActions[index];
        return GestureDetector(
          onTap: () async {
            if (!context.mounted) return; // <-- SAFE GUARD

            switch (action.label) {
              case "View New Request":
                Navigator.pushNamed(context, AppRoutes.vendorBottomBar, arguments: 1);
                break;
              case "Manage Quotation":
                Navigator.pushNamed(context, AppRoutes.vendorBottomBar, arguments: 1);
                break;
              case "Assign Employee":
                Navigator.pushNamed(context, AppRoutes.vendorBottomBar, arguments: 2);
              case "Service History":
                Navigator.pushNamed(context, AppRoutes.vendorBottomBar, arguments: 2);
                break;
              default:
              // optional: show a toast or do nothing
                break;
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: action.iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(action.icon, color: action.iconColor),
                SizedBox(width: 8),
                Expanded(child: Text(action.label)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlertsList(VendorDashboardNotifier notifier) {
    return Column(
      children: notifier.alerts.map((alert) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: AppStyles.commonDecoration,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(color: alert.iconBgColor, borderRadius: BorderRadius.circular(8.r)),
                  child: Icon(alert.icon, color: alert.iconColor, size: 20.w),
                ),
                15.horizontalSpace,
                Expanded(child: Text(alert.message, style: AppFonts.text14.regular.style)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
