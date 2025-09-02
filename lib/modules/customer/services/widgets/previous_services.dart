import 'package:community_app/core/model/customer/job/customer_history_list_response.dart';
import 'package:community_app/modules/customer/services/services_notifier.dart';
import 'package:community_app/modules/customer/services/widgets/previous_services_card.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviousServicesWidget extends StatelessWidget {
  final List<CustomerHistoryListData> historyServices;

  const PreviousServicesWidget({super.key, required this.historyServices});

  @override
  Widget build(BuildContext context) {
    if (historyServices.isEmpty) {
      return Center(child: Text("No previous services", style: AppFonts.text14.medium.style));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          ..._buildCardListWithSpacing(),
        ],
      ),
    );
  }

  List<Widget> _buildCardListWithSpacing() {
    final List<Widget> widgets = [];

    for (int i = 0; i < historyServices.length; i++) {
      widgets.add(PreviousServiceCard(service: historyServices[i]));
      if (i != historyServices.length - 1) {
        widgets.add(20.verticalSpace); // Spacing between cards
      }
    }

    return widgets;
  }
}
