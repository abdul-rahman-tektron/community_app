import 'package:community_app/core/model/customer/job/ongoing_jobs_response.dart';
import 'package:community_app/modules/customer/jobs/jobs_notifier.dart';
import 'package:community_app/modules/customer/jobs/widgets/ongoing/card/completed_service_card.dart';
import 'package:community_app/modules/customer/jobs/widgets/ongoing/card/in_progress_service_card.dart';
import 'package:community_app/modules/customer/jobs/widgets/ongoing/card/tracking_service_card.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OngoingServicesWidget extends StatelessWidget {
  final List<CustomerOngoingJobsData> upcomingJobs;

  const OngoingServicesWidget({super.key, required this.upcomingJobs});

  @override
  Widget build(BuildContext context) {
    final grouped = {
      for (final status in JobStatusCategory.values)
        status: upcomingJobs.where((job) {
          final jobStatus =
          CommonUtils.jobStatusFromString(job.jobStatusCategory);
          if (job.jobStatusCategory?.toLowerCase() == "paymentpending") {
            return status == JobStatusCategory.completed;
          }
          return jobStatus == status;
        }).toList(),
    };

    final hasJobs = grouped.values.any((jobs) => jobs.isNotEmpty);

    return RefreshIndicator(
      onRefresh: () async {
        final notifier = context.read<JobsNotifier>();
        await notifier.initializeData();
      },
      child: buildBody(context, hasJobs, grouped),
    );
  }

  Widget buildBody(BuildContext context, bool hasJobs,
      Map<JobStatusCategory, List<CustomerOngoingJobsData>> grouped) {
    if (!hasJobs) {
      return Center(child: Text("No ongoing jobs."));
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...JobStatusCategory.values.map((status) {
            final jobs = grouped[status]!;
            if (jobs.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...jobs.map((job) {
                  switch (status) {
                    case JobStatusCategory.tracking:
                      return TrackingServiceCard(job: job);
                    case JobStatusCategory.inProgress:
                      return InProgressServiceCard(service: job);
                    case JobStatusCategory.completed:
                      return CompletedServiceCard(service: job);
                    case JobStatusCategory.unknown:
                      return const SizedBox.shrink();
                  }
                }),
              ],
            );
          }),
        ],
      ),
    );
  }
}
