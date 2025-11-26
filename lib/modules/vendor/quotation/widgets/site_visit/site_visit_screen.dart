import 'package:Xception/modules/vendor/quotation/widgets/site_visit/site_visit_notifier.dart';
import 'package:Xception/modules/vendor/quotation/widgets/site_visit_detail/site_visit_detail_screen.dart';
import 'package:Xception/res/colors.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/res/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SiteVisitScreen extends StatelessWidget {
  const SiteVisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SiteVisitNotifier()..loadSiteVisits(),
      child: Consumer<SiteVisitNotifier>(
        builder: (context, notifier, _) {
          return Scaffold(
            body: notifier.siteVisits.isEmpty
                ? const Center(child: Text("No site visit requests"))
                : ListView.separated(
              padding: const EdgeInsets.all(15),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: notifier.siteVisits.length,
              itemBuilder: (context, index) {
                final request = notifier.siteVisits[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SiteVisitDetailScreen(jobId: request.id),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: AppStyles.commonDecoration,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(request.customerName, style: AppFonts.text16.semiBold.style),
                              Text(request.serviceName, style: AppFonts.text14.regular.style),
                              Text("Requested: ${request.requestedDate}", style: AppFonts.text12.regular.style),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
