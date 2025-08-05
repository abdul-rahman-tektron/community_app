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
    return Scaffold(
      body: notifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifier.quotations.isEmpty
          ? const Center(child: Text("No quotations sent."))
          : ListView.builder(
        itemCount: notifier.quotations.length,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (context, index) {
          final quotation = notifier.quotations[index];
          if (quotation.quotationResponseStatus?.toLowerCase() != "submitted") {
            return const SizedBox.shrink(); // Don't display if not "Initiated"
          }
          return QuotationCard(
            quotation: quotation,
            onViewDetails: () {
              Navigator.pushNamed(context, AppRoutes.quotationDetails, arguments: quotation);
            },
            onResend: (quotation.quotationResponseStatus ?? "").toLowerCase() == "rejected"
                ? () {
              // Handle resend logic
            }
                : null,
          );
        },
      ),
    );
  }
}
