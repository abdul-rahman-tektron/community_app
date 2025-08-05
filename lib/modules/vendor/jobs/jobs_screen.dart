import 'package:community_app/modules/vendor/jobs/jobs_notifier.dart';
import 'package:community_app/modules/vendor/jobs/widgets/job_history/job_history_screen.dart';
import 'package:community_app/modules/vendor/jobs/widgets/ongoing_service/ongoing_service_screen.dart';
import 'package:community_app/modules/vendor/quotation/quotation_notifier.dart';
import 'package:community_app/modules/vendor/quotation/widgets/new_request/new_request_screen.dart';
import 'package:community_app/modules/vendor/quotation/widgets/sent_quotation/sent_quotation_screen.dart';
import 'package:community_app/modules/vendor/quotation/widgets/updated_quotation/updated_quotation_screen.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class JobsScreen extends StatelessWidget {
  final int? currentIndex;
  const JobsScreen({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChangeNotifierProvider(
        create: (context) => JobsNotifier(currentIndex),
        child: Consumer<JobsNotifier>(
          builder: (context, jobsNotifier, child) {
            return buildBody(context, jobsNotifier);
          },
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context, JobsNotifier jobsNotifier) {
    return DefaultTabController(
      length: 2,
      initialIndex: jobsNotifier.selectedIndex,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: tabBar(context, jobsNotifier),
            ),
            tabBarView(context, jobsNotifier),
          ],
        ),
      ),
    );
  }

  Widget tabBar(BuildContext context, JobsNotifier jobsNotifier) {
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
            jobsNotifier.selectedIndex = index;
            if (index == 0) {

            } else {

            }
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

  Widget tabBarView(BuildContext context, JobsNotifier jobsNotifier) {
    return Expanded(child: TabBarView(children: [ OngoingServiceScreen(), JobHistoryScreen()]));
  }
}
