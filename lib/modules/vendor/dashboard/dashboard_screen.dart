import 'package:community_app/res/colors.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:fl_chart/fl_chart.dart';
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
                  // _buildLicenseAlertCard(notifier),
                  // 15.verticalSpace,
                  _buildLicenseStatusCard(notifier),
                  25.verticalSpace,

                  Text("Quick Stats", style: AppFonts.text16.semiBold.style),
                  10.verticalSpace,
                  _buildQuickStatsGrid(notifier),
                  15.verticalSpace,
                  _buildServiceStatusPieChart(notifier),
                  25.verticalSpace,
                  Text("Quick Actions", style: AppFonts.text16.semiBold.style),
                  10.verticalSpace,
                  buildQuickActions(context, notifier),
                  25.verticalSpace,

                  // Text("Alerts", style: AppFonts.text16.semiBold.style),
                  // _buildAlertsList(notifier),
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
        border: Border(left: BorderSide(color: Colors.red, width: 5.0)),
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
        childAspectRatio: 1 / 0.6,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemBuilder: (context, index) {
        final stat = notifier.quickStats[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: AppStyles.commonDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(color: stat.iconBgColor, borderRadius: BorderRadius.circular(8.r)),
                    child: Icon(stat.icon, color: stat.iconColor, size: 20.w),
                  ),
                  15.horizontalSpace,
                  Text(stat.count.toString(), style: AppFonts.text24.semiBold.style, overflow: TextOverflow.ellipsis),
                ],
              ),
              15.verticalSpace,
              Text(stat.label, style: AppFonts.text14.regular.style),
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
                Navigator.pushNamed(
                  context,
                  AppRoutes.vendorBottomBar,
                  arguments: {"currentIndex": 1, "subCurrentIndex": 0},
                );
                break;
              case "Manage Quotation":
                Navigator.pushNamed(
                  context,
                  AppRoutes.vendorBottomBar,
                  arguments: {"currentIndex": 1, "subCurrentIndex": 1}, // Quotation > Manage Quotation tab
                );
                break;
              case "Assign Employee":
                Navigator.pushNamed(
                  context,
                  AppRoutes.vendorBottomBar,
                  arguments: {"currentIndex": 2, "subCurrentIndex": 0},
                );
              case "Service History":
                Navigator.pushNamed(
                  context,
                  AppRoutes.vendorBottomBar,
                  arguments: {"currentIndex": 2, "subCurrentIndex": 1},
                );
                break;
              default:
                // optional: show a toast or do nothing
                break;
            }
          },
          child: Container(
            decoration: BoxDecoration(color: action.iconBgColor, borderRadius: BorderRadius.circular(12)),
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

  List<PieChartSectionData> getServiceStatusPieData(
      VendorDashboardNotifier notifier, {
        int touchedIndex = -1,
      }) {
    final acceptedCount = notifier.acceptedCount ?? 0;
    final rejectedCount = notifier.rejectedCount ?? 0;
    final total = acceptedCount + rejectedCount;

    // Handle 0 case
    final acceptedValue = total == 0 ? 50.0 : acceptedCount.toDouble();
    final rejectedValue = total == 0 ? 50.0 : rejectedCount.toDouble();

    final acceptedPercent = total == 0 ? 0 : (acceptedCount / total) * 100;
    final rejectedPercent = total == 0 ? 0 : (rejectedCount / total) * 100;

    List<PieChartSectionData> sections = [];

    sections.add(
      PieChartSectionData(
        color: const Color(0xFF81C784),
        value: acceptedValue,
        title: '${acceptedPercent.toStringAsFixed(1)}%',
        radius: touchedIndex == 0 ? 60 : 50,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 0 ? 18 : 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );

    sections.add(
      PieChartSectionData(
        color: const Color(0xFFE57373),
        value: rejectedValue,
        title: '${rejectedPercent.toStringAsFixed(1)}%',
        radius: touchedIndex == 1 ? 60 : 50,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 1 ? 18 : 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );

    return sections;
  }


  Widget _buildServiceStatusPieChart(VendorDashboardNotifier notifier) {
    int touchedIndex = -1;

    return Container(
      decoration: AppStyles.commonDecoration,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: StatefulBuilder(
              builder: (context, setState) {
                return SizedBox(
                  height: 180.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (event, response) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    response == null ||
                                    response.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = response.touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 2,
                          centerSpaceRadius: 35.w, // <-- dynamically scaled
                          sections: getServiceStatusPieData(notifier, touchedIndex: touchedIndex),
                        ),
                      ),
                      // Center content
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.pencilRuler, size: 20.w, color: AppColors.textPrimary),
                          4.verticalSpace,
                          Text(
                            "Jobs",
                            style: AppFonts.text14.bold.style
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFF81C784)),
                    ),
                    10.horizontalSpace,
                    Text("Accepted", style: AppFonts.text14.regular.style),
                  ],
                ),
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFE57373)),
                    ),
                    10.horizontalSpace,
                    Text("Rejected", style: AppFonts.text14.regular.style),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
