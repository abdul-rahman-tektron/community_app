import 'package:Xception/modules/vendor/quotation/widgets/sent_quotation/quotation_card.dart';
import 'package:Xception/modules/vendor/quotation/widgets/sent_quotation/sent_quotation_notifier.dart';
import 'package:Xception/res/colors.dart';
import 'package:Xception/utils/enums.dart';
import 'package:Xception/utils/helpers/common_utils.dart';
import 'package:Xception/utils/helpers/loader.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:Xception/utils/widgets/custom_refresh_indicator.dart';
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
      return status != "accepted" &&
          status != "" &&
          request.status != AppStatus.quotationAccepted.name;
    }).toList();

    return Scaffold(
      body: CustomRefreshIndicator(
        onRefresh: () async {
          await notifier.initializeData();
        },
        child: notifier.isLoading
            ? Center(child: LottieLoader())
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
                    onResend: (quotation.status ?? "") == AppStatus.vendorQuotationRejected.name
                        ? () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.addQuotation,
                              arguments: {
                                'jobId': quotation.jobId,
                                'serviceId': quotation.serviceId,
                                'quotationId': quotation.quotationId,
                                'customerId': quotation.fromCustomerId,
                                'isSiteVisit': quotation.isAcceptedByCustomer,
                                'quotationResponseId': quotation.quotationResponseId,
                                'isResend': true,
                              },
                            ).then((value) {
                              notifier.initializeData();
                            });
                          }
                        : null,
                  );
                },
              ),
      ),
    );
  }
}
