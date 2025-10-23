import 'package:community_app/core/model/vendor/jobs/ongoing_jobs_assigned_response.dart';
import 'package:community_app/modules/vendor/jobs/widgets/ongoing_service/ongoing_service_card.dart';
import 'package:community_app/modules/vendor/jobs/widgets/ongoing_service/ongoing_service_notifier.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:community_app/utils/helpers/loader.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OngoingServiceScreen extends StatelessWidget {
  const OngoingServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OngoingServiceNotifier(),
      child: Consumer<OngoingServiceNotifier>(
        builder: (context, notifier, _) {
          return CustomRefreshIndicator(
            onRefresh: () async {
              await notifier.initializeData();
            },
            child: buildBody(context, notifier),
          );
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, OngoingServiceNotifier notifier) {
    if (notifier.isLoading) {
      return const Center(child: LottieLoader());
    }

    if (notifier.ongoingJobs.isEmpty) {
      return const Center(child: Text("No ongoing jobs."));
    }

    // ✅ Sort ongoing jobs by jobId descending (latest first)
    final sortedJobs = [...notifier.ongoingJobs]
      ..sort((a, b) => (b.jobId ?? 0).compareTo(a.jobId ?? 0));

    return ListView.builder(
      itemCount: sortedJobs.length,
      itemBuilder: (context, index) {
        final job = sortedJobs[index];

        final status = AppStatus.fromName(job.status ?? "");

        // Skip jobs that are beyond status 12, except hold/rework
        if ((status?.id ?? 0) > 12 &&
            status?.name != AppStatus.holdTheJob.name &&
            status?.name != AppStatus.rework.name) {
          return const SizedBox.shrink();
        }

        return OngoingServiceCard(
          job: job,
          onViewDetails: () {
            Navigator.pushNamed(
              context,
              AppRoutes.progressUpdate,
              arguments: {
                "jobId": job.jobId,
                "customerId": job.customerId,
                "status": job.status,
                "reworkNotes": job.customerRemarks,
              },
            ).then((value) {
              notifier.initializeData();
            });
          },
        );
      },
    );
  }
}