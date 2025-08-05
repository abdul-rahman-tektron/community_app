import 'package:community_app/modules/vendor/quotation/widgets/new_request/new_request_card.dart';
import 'package:community_app/modules/vendor/quotation/widgets/new_request/new_request_notifier.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewRequestScreen extends StatelessWidget {
  const NewRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewRequestNotifier(),
      child: Consumer<NewRequestNotifier>(
        builder: (context, notifier, _) {
          return Scaffold(
            body: notifier.requests.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: notifier.requests.length,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (context, index) {
                final request = notifier.requests[index];

                // Check response status for each item
                if (request.quotationResponseStatus?.toLowerCase() != "initiated") {
                  return const SizedBox.shrink(); // Don't display if not "Initiated"
                }

                return NewRequestCard(
                  request: request,
                  onQuotationTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.addQuotation,
                      arguments: {
                        'jobId': request.jobId,
                        'serviceId': 1001,
                        'quotationId': request.quotationId,
                      },
                    );
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
