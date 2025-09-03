import 'package:community_app/res/colors.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/screen_size.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_refresh_indicator.dart';
import 'package:community_app/utils/widgets/ratings_helper.dart';
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
          return buildBody(context, notifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, VendorDashboardNotifier notifier) {
    return CustomRefreshIndicator(
      onRefresh: () async {
        await notifier.initializeData();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLicenseStatusCard(notifier),
              25.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: Text("Quick Stats", style: AppFonts.text16.semiBold.style.copyWith(
                      fontSize: ScreenSize.width < 380 ? 14 : 16,
                    ),),
                  ),
                  RatingsHelper(rating: notifier.ratings ?? 0, size: ScreenSize.width < 380 ? 15 : 20,),
                  Text(" (${notifier.ratings ?? 0})", style: AppFonts.text14.regular.style,)
                ],
              ),
              10.verticalSpace,
              _buildQuickStatsGrid(notifier),
              15.verticalSpace,
              _buildServiceStatusPieChart(notifier),
              // 15.verticalSpace,
              // ratingWidget(notifier),
              25.verticalSpace,
              Text("Quick Actions", style: AppFonts.text16.semiBold.style.copyWith(
                fontSize: ScreenSize.width < 380 ? 14 : 16,
              ),),
              10.verticalSpace,
              buildQuickActions(context, notifier),
              25.verticalSpace,

              // Text("Alerts", style: AppFonts.text16.semiBold.style),
              // _buildAlertsList(notifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLicenseStatusCard(VendorDashboardNotifier notifier) {
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
          Text("Trade License Status", style: AppFonts.text16.semiBold.style.copyWith(
            fontSize: ScreenSize.width < 380 ? 14 : 16,
          ),),
          10.verticalSpace,
          _buildKeyValueRow("License ID", notifier.documentData?.documentNumber ?? ""),
          5.verticalSpace,
          _buildKeyValueRow(
            "Expiry Date",
            notifier.documentData?.documentExpiryDate?.formatDate() ?? "",
          ),
          5.verticalSpace,
          _buildKeyValueRow(
            "Status",
            notifier.documentData?.active ?? false ? "Active" : "Inactive",
            valueColor: notifier.documentData?.active ?? false ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildKeyValueRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppFonts.text14.regular.style.copyWith(
          fontSize: ScreenSize.width < 380 ? 12 : 14,
        ),),
        Flexible(
          child: Text(
            value,
            style: AppFonts.text14.regular.style.copyWith(
              fontSize: ScreenSize.width < 380 ? 12 : 14,
              color: valueColor ?? AppColors.textPrimary,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget ratingWidget(VendorDashboardNotifier notifier) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: AppStyles.commonDecoration,
      child: RatingsHelper(rating: notifier.ratings ?? 0, size: 40,),
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
                    decoration: BoxDecoration(
                      color: stat.iconBgColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(stat.icon, color: stat.iconColor, size: 20.w),
                  ),
                  15.horizontalSpace,
                  Text(
                    stat.count.toString(),
                    style: AppFonts.text24.semiBold.style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              15.verticalSpace,
              Text(
                stat.label,
                style: AppFonts.text12.regular.style.copyWith(
                  fontSize: ScreenSize.width < 380 ? 10 : 12,
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
                  arguments: {
                    "currentIndex": 1,
                    "subCurrentIndex": 1,
                  }, // Quotation > Manage Quotation tab
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
            decoration: BoxDecoration(
              color: action.iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(action.icon, color: action.iconColor),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    action.label,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.text12.regular.style.copyWith(
                      fontSize: ScreenSize.width < 380 ? 10 : 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
        titleStyle: AppFonts.text12.regular.white.style.copyWith(
          fontSize: touchedIndex == 0 ? 14 : 12,
        )
      ),
    );

    sections.add(
      PieChartSectionData(
        color: const Color(0xFFE57373),
        value: rejectedValue,
        title: '${rejectedPercent.toStringAsFixed(1)}%',
        radius: touchedIndex == 1 ? 60 : 50,
        titleStyle: AppFonts.text12.regular.white.style.copyWith(
          fontSize: touchedIndex == 0 ? 14 : 12,
        ),
      ),
    );

    return sections;
  }

  Widget _buildServiceStatusPieChart(VendorDashboardNotifier notifier) {
    int touchedIndex = -1;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Take available width from the Row for pie chart
        double pieSize = constraints.maxWidth * 0.45; // 45% of total row width
        pieSize = pieSize.clamp(120.0, 200.0); // min/max size

        return Container(
          decoration: AppStyles.commonDecoration,
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return SizedBox(
                      width: pieSize,
                      height: pieSize,
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
                              centerSpaceRadius: pieSize * 0.2,
                              sections: getServiceStatusPieData(
                                notifier,
                                touchedIndex: touchedIndex,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.pencilRuler,
                                size: pieSize * 0.12,
                                color: AppColors.textPrimary,
                              ),
                              SizedBox(height: 4),
                              Text("Jobs", style: AppFonts.text14.bold.style),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF81C784),
                          ),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            "Accepted",
                            style: AppFonts.text14.regular.style.copyWith(
                              fontSize: ScreenSize.width < 380 ? 12 : 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE57373),
                          ),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            "Rejected",
                            style: AppFonts.text14.regular.style.copyWith(
                              fontSize: ScreenSize.width < 380 ? 12 : 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
