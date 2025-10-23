import 'package:community_app/modules/vendor/quotation/widgets/new_request/new_request_card.dart';
import 'package:community_app/modules/vendor/quotation/widgets/new_request/new_request_notifier.dart';
import 'package:community_app/modules/vendor/quotation/widgets/new_request/site_visit_card.dart';
import 'package:community_app/modules/vendor/quotation/widgets/site_visit_detail/site_visit_detail_screen.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:community_app/utils/helpers/loader.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_refresh_indicator.dart';
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
    // Filter unwanted requests
    final filteredRequests = notifier.requests.where((request) {
      final quotationStatus =
          request.quotationResponseStatus?.trim().toLowerCase() ?? "";
      final jobStatus = request.status?.trim() ?? "";

      return quotationStatus != "accepted" &&
          quotationStatus != "submitted" &&
          jobStatus != AppStatus.vendorQuotationRejected.name;
    }).toList();

    // ✅ Sort by jobId descending (latest first)
    filteredRequests.sort((a, b) => (b.jobId ?? 0).compareTo(a.jobId ?? 0));

    return Scaffold(
      body: CustomRefreshIndicator(
        onRefresh: () async {
          await notifier.initializeData();
        },
        child: notifier.isLoading
            ? const Center(child: LottieLoader())
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
                  AppRoutes.addQuotation,
                  arguments: {
                    'jobId': request.jobId,
                    'serviceId': request.serviceId,
                    'quotationId': request.quotationId,
                    'customerId': request.fromCustomerId,
                    'isSiteVisit': request.isAcceptedByCustomer,
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
      ),
    );
  }
}