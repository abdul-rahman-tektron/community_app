import 'package:community_app/core/model/customer/quotation/quotation_request_list_response.dart';
import 'package:community_app/modules/customer/dashboard/quotation_list/quotation_request_list_notifier.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/loader.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class QuotationRequestListScreen extends StatelessWidget {
  const QuotationRequestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuotationRequestListNotifier(),
      child: Consumer<QuotationRequestListNotifier>(
        builder: (_, notifier, __) {
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(),
              body: notifier.isLoading
                  ? const Center(child: LottieLoader())
                  : notifier.requests.isEmpty
                  ? const Center(child: Text("No Requests found"))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          15.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [_buildHeader()],
                          ),
                          10.verticalSpace,
                          ..._buildFilteredRequests(context, notifier),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildFilteredRequests(
    BuildContext context,
    QuotationRequestListNotifier notifier,
  ) {
    final filteredRequests = notifier.requests
        .where((r) => r.status != "Accepted") // <-- your condition here
        .toList()
        .reversed
        .toList();

    if (filteredRequests.isEmpty) {
      return [const Center(child: Text("No Requests found"))];
    }

    return List.generate(filteredRequests.length, (i) {
      final request = filteredRequests[i];
      return _buildRequestCard(context, notifier, i, request);
    });
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Text("Job Request List", style: AppFonts.text20.semiBold.style),
        ],
      ),
    );
  }

  Widget _buildRequestCard(
    BuildContext context,
    QuotationRequestListNotifier notifier,
    int index,
    CustomerRequestListData request,
  ) {
    return GestureDetector(
      onTap: () {
        if (request.distributions?.isNotEmpty ?? false) {
          Navigator.pushNamed(
            context,
            AppRoutes.quotationList,
            arguments: request.jobId,
          ).then((value) {
            notifier.apiQuotationRequestList();
          });
        } else {
          Navigator.pushNamed(
            context,
            AppRoutes.topVendors,
            arguments: {'jobId': request.jobId, 'serviceId': request.serviceId},
          ).then((value) {
            notifier.apiQuotationRequestList();
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: double.infinity,
        decoration: AppStyles.commonDecoration,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  notifier.getServiceNameById(request.serviceId),
                  style: AppFonts.text14.bold.style,
                ),
                Text(
                  "#${request.jobId}",
                  style: AppFonts.text14.bold.style,
                ),
              ],
            ),
            10.verticalSpace,
            Text(
              "Remarks: ${request.remarks}",
              style: AppFonts.text12.medium.style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(request.siteVisitRequired ?? false) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xffe7f3f9),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text("Site Visit Required", style: AppFonts.text14.regular.style.copyWith(color: Colors.blue)),
                ),
                Text(
                  "${request.expectedDate?.formatDate()}",
                  style: AppFonts.text12.medium.style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
