import 'package:Xception/core/model/customer/job/customer_history_list_response.dart';
import 'package:Xception/modules/customer/jobs/widgets/history/history_services_card.dart';
import 'package:Xception/res/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryServicesWidget extends StatelessWidget {
  final List<CustomerHistoryListData> historyServices;

  const HistoryServicesWidget({super.key, required this.historyServices});

  @override
  Widget build(BuildContext context) {
    if (historyServices.isEmpty) {
      return Center(
        child: Text(
          "No previous jobs",
          style: AppFonts.text14.medium.style,
        ),
      );
    }

    // ✅ Sort history by jobId descending (latest first)
    final sortedHistory = [...historyServices]
      ..sort((a, b) => (b.jobId ?? 0).compareTo(a.jobId ?? 0));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.verticalSpace,
          ..._buildCardListWithSpacing(sortedHistory),
        ],
      ),
    );
  }

  List<Widget> _buildCardListWithSpacing(List<CustomerHistoryListData> services) {
    final List<Widget> widgets = [];

    for (int i = 0; i < services.length; i++) {
      widgets.add(HistoryServiceCard(service: services[i]));
      if (i != services.length - 1) {
        widgets.add(15.verticalSpace); // spacing between cards
      }
    }

    return widgets;
  }
}