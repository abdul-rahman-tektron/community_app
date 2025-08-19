import 'package:community_app/modules/vendor/quotation/widgets/sent_quotation/quotation_card.dart';
import 'package:community_app/modules/vendor/quotation/widgets/sent_quotation/sent_quotation_notifier.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SentQuotationScreen extends StatelessWidget {
  const SentQuotationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SentQuotationNotifier(),
      child: Consumer<SentQuotationNotifier>(
        builder: (context, sentQuotationNotifier, child) {
          return buildBody(context, sentQuotationNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, SentQuotationNotifier notifier) {
    final filteredQuotations = notifier.quotations.where((request) {
      final status = request.quotationResponseStatus?.toLowerCase();
      return status != "accepted" && status != "";
    }).toList();

    return Scaffold(
      body: notifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredQuotations.isEmpty
          ? const Center(child: Text("No quotations sent."))
          : ListView.builder(
        itemCount: filteredQuotations.length,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (context, index) {
          final quotation = filteredQuotations[index];
          return QuotationCard(
            quotation: quotation,
            onViewDetails: () {
              Navigator.pushNamed(
                context,
                AppRoutes.quotationDetails,
                arguments: {
                  'jobId': quotation.jobId,
                  'quotationResponseId': quotation.quotationResponseId,
                },
              ).then((value) {
                notifier.initializeData();
              });
            },
            onResend: (quotation.quotationResponseStatus ?? "").toLowerCase() == "rejected"
                ? () {}
                : null,
          );
        },
      ),
    );
  }
}
