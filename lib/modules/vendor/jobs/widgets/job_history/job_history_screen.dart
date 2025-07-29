import 'package:community_app/modules/vendor/jobs/widgets/job_history/job_history_notifier.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
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
              padding: const EdgeInsets.all(15),
              itemCount: notifier.jobHistory.length,
              itemBuilder: (context, index) {
                final job = notifier.jobHistory[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.jobHistoryDetail,
                      arguments: job['id'],
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(job['customerName'], style: AppFonts.text16.semiBold.style),
                      subtitle: Text("${job['service']} • ${job['location']}"),
                      trailing: Text("AED ${job['amount']}", style: AppFonts.text14.semiBold.style),
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
