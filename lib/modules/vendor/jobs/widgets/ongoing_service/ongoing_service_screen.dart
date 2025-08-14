import 'package:community_app/core/model/vendor/jobs/ongoing_jobs_assigned_response.dart';
import 'package:community_app/modules/vendor/jobs/widgets/ongoing_service/ongoing_service_card.dart';
import 'package:community_app/modules/vendor/jobs/widgets/ongoing_service/ongoing_service_notifier.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
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
              final reversedJobs = notifier.ongoingJobs.reversed.toList();
              final job = reversedJobs[index];

              if((AppStatus.fromName(job.status ?? "")?.id ?? 0) > 12) {
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
                    },
                  ).then((value) {
                    notifier.initializeData();
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
