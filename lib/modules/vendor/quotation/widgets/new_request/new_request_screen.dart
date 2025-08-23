import 'package:community_app/modules/vendor/quotation/widgets/new_request/new_request_card.dart';
import 'package:community_app/modules/vendor/quotation/widgets/new_request/new_request_notifier.dart';
import 'package:community_app/modules/vendor/quotation/widgets/new_request/site_visit_card.dart';
import 'package:community_app/modules/vendor/quotation/widgets/site_visit_detail/site_visit_detail_screen.dart';
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
          return buildBody(context, notifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, NewRequestNotifier notifier) {
    final filteredRequests = notifier.requests.where((request) {
      final status = request.quotationResponseStatus?.toLowerCase();
      return status != "accepted" && status != "submitted";
    }).toList();

    return Scaffold(
      body: notifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredRequests.isEmpty
          ? const Center(child: Text("No new requests."))
          : ListView.builder(
              itemCount: filteredRequests.length,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (context, index) {
                final request = filteredRequests[index];

                return request.siteVisit == true
                    ? SiteVisitCard(
                        request: request,
                        onQuotationTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.siteVisitDetail,
                            arguments: {
                              'jobId': request.jobId?.toString(),
                              'customerId': request.fromCustomerId,
                              'siteVisitId': request.siteVisitId,
                            },
                          ).then((value) {
                            notifier.initializeData();
                          });
                        },
                        onCallTap: () {
                          notifier.openDialer(request.customerMobile ?? '');
                        },
                      )
                    : NewRequestCard(
                        request: request,
                        onQuotationTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.addQuotation,
                            arguments: {
                              'jobId': request.jobId,
                              'serviceId': request.serviceId,
                              'quotationId': request.quotationId,
                              'customerId': request.fromCustomerId,
                            },
                          ).then((value) {
                            notifier.initializeData();
                          });
                        },
                        onCallTap: () {
                          notifier.openDialer(request.customerMobile ?? '');
                        },
                      );
              },
            ),
    );
  }
}
