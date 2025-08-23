import 'package:community_app/modules/vendor/jobs/widgets/job_history/job_history_notifier.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class JobHistoryScreen extends StatelessWidget {
  const JobHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JobHistoryNotifier(),
      child: Consumer<JobHistoryNotifier>(
        builder: (context, notifier, child) {
          if (notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            body: ListView.builder(
              // padding: const EdgeInsets.all(15),
              itemCount: notifier.historyServices.length,
              itemBuilder: (context, index) {
                final job = notifier.historyServices[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.jobHistoryDetail,
                      arguments: job.jobId ?? 0,
                    );
                  },
                  child: Container(
                    decoration: AppStyles.commonDecoration,
                    margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(job.customerName ?? "", style: AppFonts.text16.semiBold.style)),
                                  Text("#${job.jobId ?? ""}", style: AppFonts.text16.regular.style),
                                ],
                              ),
                              5.verticalSpace,
                              Row(
                                children: [
                                  Expanded(child: Text("${job.serviceName}", style: AppFonts.text14.regular.style,)),
                                  Text("AED ${job.quotedAmount}", style: AppFonts.text14.regular.style),
                                ],
                              ),
                              10.verticalSpace,
                              Text("${job.address}", style: AppFonts.text14.regular.style,)
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
