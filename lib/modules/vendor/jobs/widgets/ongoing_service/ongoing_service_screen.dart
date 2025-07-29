
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
          return Scaffold(
            body: notifier.ongoingJobs.isEmpty
                ? const Center(child: Text("No ongoing jobs."))
                : ListView.builder(
              itemCount: notifier.ongoingJobs.length,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (context, index) {
                final job = notifier.ongoingJobs[index];
                return OngoingServiceCard(
                  job: job,
                  onViewDetails: () {
                    Navigator.pushNamed(context, AppRoutes.progressUpdate);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
