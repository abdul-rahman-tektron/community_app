import 'package:community_app/core/model/customer/job/ongoing_jobs_response.dart';
import 'package:community_app/modules/customer/services/services_notifier.dart';
import 'package:community_app/modules/customer/services/widgets/completed_service_card.dart';
import 'package:community_app/modules/customer/services/widgets/in_progress_service_card.dart';
import 'package:community_app/modules/customer/services/widgets/tracking_service_card.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:flutter/material.dart';

class UpcomingServicesWidget extends StatelessWidget {
  final List<CustomerOngoingJobsData> upcomingJobs;

  const UpcomingServicesWidget({super.key, required this.upcomingJobs});

  @override
  Widget build(BuildContext context) {
    // Group by jobStatusCategory enum
    final Map<JobStatusCategory, List<CustomerOngoingJobsData>> grouped = {
      for (var status in JobStatusCategory.values)
        status: upcomingJobs
            .where((job) => CommonUtils.jobStatusFromString(job.jobStatusCategory) == status)
            .toList(),
    };

    return SingleChildScrollView(
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
                    return SizedBox.shrink();
                  }
                }),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _statusLabel(JobStatusCategory status) {
    switch (status) {
      case JobStatusCategory.tracking:
        return "Tracking";
      case JobStatusCategory.inProgress:
        return "In Progress";
      case JobStatusCategory.completed:
        return "Completed";
      case JobStatusCategory.unknown:
      default:
        return "Other";
    }
  }
}
