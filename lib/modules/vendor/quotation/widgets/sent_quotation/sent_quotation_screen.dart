import 'package:community_app/modules/vendor/quotation/widgets/sent_quotation/quotation_card.dart';
import 'package:community_app/modules/vendor/quotation/widgets/sent_quotation/sent_quotation_notifier.dart';
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

  Widget buildBody(BuildContext context, SentQuotationNotifier sentQuotationNotifier) {
    return Scaffold(
      body: sentQuotationNotifier.quotations.isEmpty
          ? const Center(child: Text("No quotations sent."))
          : ListView.builder(
        itemCount: sentQuotationNotifier.quotations.length,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (context, index) {
          final quotation = sentQuotationNotifier.quotations[index];
          return QuotationCard(
            quotation: quotation,
            onViewDetails: () {
              // Handle view details
              Navigator.pushNamed(context, AppRoutes.quotationDetails);
            },
            onResend: quotation.status == QuotationStatus.rejected
                ? () {
              // Handle resend logic
              // sentQuotationNotifier.resendQuotation(quotation);
            }
                : null,
          );
        },
      ),
    );
  }


}
