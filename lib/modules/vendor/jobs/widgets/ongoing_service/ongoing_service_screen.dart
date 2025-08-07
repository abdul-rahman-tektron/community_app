import 'package:community_app/core/model/vendor/jobs/ongoing_jobs_assigned_response.dart';
import 'package:community_app/modules/vendor/jobs/widgets/ongoing_service/ongoing_service_card.dart';
import 'package:community_app/modules/vendor/jobs/widgets/ongoing_service/ongoing_service_notifier.dart';
import 'package:community_app/utils/router/routes.dart';
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
          if (notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notifier.ongoingJobs.isEmpty) {
            return const Center(child: Text("No ongoing jobs."));
          }
          return ListView.builder(
            itemCount: notifier.ongoingJobs.length,
            itemBuilder: (context, index) {
              final job = notifier.ongoingJobs[index];
              return OngoingServiceCard(
                job: OngoingJobsAssignedData(),
                onViewDetails: () {
                  Navigator.pushNamed(context, AppRoutes.progressUpdate,
                      arguments: {"jobId": job.jobId, "status": job.jobStatusCategory});
                },
              );
            },
          );
        },
      ),
    );
  }
}
