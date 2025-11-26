import 'package:Xception/modules/customer/jobs/jobs_notifier.dart';
import 'package:Xception/modules/customer/jobs/widgets/history/history_services.dart';
import 'package:Xception/modules/customer/jobs/widgets/new_service_button.dart';
import 'package:Xception/modules/customer/jobs/widgets/ongoing/ongoing_services.dart';
import 'package:Xception/res/colors.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/utils/helpers/loader.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JobsNotifier(),
      child: Consumer<JobsNotifier>(
        builder: (context, servicesNotifier, child) {
          return buildBody(context, servicesNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, JobsNotifier servicesNotifier) {
    return DefaultTabController(
      length: 2,
      initialIndex: servicesNotifier.selectedIndex,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NewServiceButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.newServices);
                  },
                ),
                10.verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: tabBar(context, servicesNotifier),
                ),
                5.verticalSpace,
                tabBarView(context, servicesNotifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tabBar(BuildContext context, JobsNotifier servicesNotifier) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 45.h),
      child: Container(
        padding: EdgeInsets.all(0), // space around the indicator
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.white,
          boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 7)],
        ),
        child: TabBar(
          labelColor: AppColors.primary,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: AppColors.primary, width: 3.0),
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: (index) {
            servicesNotifier.selectedIndex = index;
            if (index == 0) {
            } else {}
          },
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: AppFonts.text14.regular.style,
          unselectedLabelStyle: AppFonts.text14.regular.style,
          tabs: [
            Tab(text: "Ongoing"),
            Tab(text: "History"),
          ],
        ),
      ),
    );
  }

  Widget tabBarView(BuildContext context, JobsNotifier servicesNotifier) {
    return Expanded(
      child: TabBarView(
        children: [
          servicesNotifier.isLoading
              ? Center(child: LottieLoader())
              : OngoingServicesWidget(upcomingJobs: servicesNotifier.upcomingServices),
          servicesNotifier.isLoading
              ? Center(child: LottieLoader())
              : HistoryServicesWidget(historyServices: servicesNotifier.historyServices),
        ],
      ),
    );
  }
}
