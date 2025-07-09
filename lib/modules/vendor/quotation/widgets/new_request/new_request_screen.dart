import 'package:community_app/modules/vendor/quotation/widgets/new_request/new_request_card.dart';
import 'package:community_app/modules/vendor/quotation/widgets/new_request/new_request_notifier.dart';
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
                ? const Center(child: Text("No new requests."))
                : ListView.builder(
              itemCount: notifier.requests.length,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (context, index) {
                final request = notifier.requests[index];
                return NewRequestCard(
                  request: request,
                  onQuotationTap: () {
                    // Handle quotation button tap here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Create quotation for ${request.customerName}')),
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
