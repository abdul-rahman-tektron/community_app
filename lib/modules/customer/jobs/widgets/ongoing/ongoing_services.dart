import 'package:Xception/core/model/customer/job/ongoing_jobs_response.dart';
import 'package:Xception/modules/customer/jobs/jobs_notifier.dart';
import 'package:Xception/modules/customer/jobs/widgets/ongoing/card/completed_service_card.dart';
import 'package:Xception/modules/customer/jobs/widgets/ongoing/card/in_progress_service_card.dart';
import 'package:Xception/modules/customer/jobs/widgets/ongoing/card/tracking_service_card.dart';
import 'package:Xception/utils/enums.dart';
import 'package:Xception/utils/helpers/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OngoingServicesWidget extends StatelessWidget {
  final List<CustomerOngoingJobsData> upcomingJobs;

  const OngoingServicesWidget({super.key, required this.upcomingJobs});

  @override
  Widget build(BuildContext context) {
    // 1) Sort ALL jobs globally by jobId DESC
    final sortedJobs = [...upcomingJobs]
      ..sort((a, b) => (b.jobId ?? 0).compareTo(a.jobId ?? 0));

    // 2) Filter out cancelled jobs (we won't render them)
    final visibleJobs = sortedJobs
        .where((job) => job.status != AppStatus.cancelJob.name)
        .toList();

    final hasJobs = visibleJobs.isNotEmpty;

    return RefreshIndicator(
      onRefresh: () async {
        final notifier = context.read<JobsNotifier>();
        await notifier.initializeData();
      },
      // 3) Mixed list (no grouping). Each row decides its card by status.
      child: hasJobs
          ? ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: visibleJobs.length,
        itemBuilder: (context, index) {
          final job = visibleJobs[index];

          // Map raw category to enum (with special "paymentpending" handling)
          final rawCat = (job.jobStatusCategory ?? '').toLowerCase();
          final effectiveStatus = rawCat == 'paymentpending'
              ? JobStatusCategory.completed
              : CommonUtils.jobStatusFromString(job.jobStatusCategory);

          switch (effectiveStatus) {
            case JobStatusCategory.tracking:
              return TrackingServiceCard(key: ValueKey(job.jobId), job: job);

            case JobStatusCategory.inProgress:
              return InProgressServiceCard(key: ValueKey(job.jobId), service: job);

            case JobStatusCategory.completed:
              return CompletedServiceCard(key: ValueKey(job.jobId), service: job);

            case JobStatusCategory.unknown:
              return const SizedBox.shrink();
          }
        },
      )
          : ListView(
        // Keep pull-to-refresh working even when empty
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Center(child: Text("No ongoing jobs.")),
          ),
        ],
      ),
    );
  }
}