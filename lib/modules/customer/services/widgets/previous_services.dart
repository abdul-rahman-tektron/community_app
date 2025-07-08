import 'package:community_app/modules/customer/services/services_notifier.dart';
import 'package:community_app/modules/customer/services/widgets/previous_services_card.dart';
import 'package:community_app/res/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviousServicesWidget extends StatelessWidget {
  final List<ServiceModel> previousServices;

  const PreviousServicesWidget({super.key, required this.previousServices});

  @override
  Widget build(BuildContext context) {
    if (previousServices.isEmpty) {
      return Text("No previous services", style: AppFonts.text14.medium.style);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text("Previous Services", style: AppFonts.text18.semiBold.style),
        ),
        15.verticalSpace,
        ..._buildCardListWithSpacing(),
        15.verticalSpace,
      ],
    );
  }

  List<Widget> _buildCardListWithSpacing() {
    final List<Widget> widgets = [];

    for (int i = 0; i < previousServices.length; i++) {
      widgets.add(PreviousServiceCard(service: previousServices[i]));
      if (i != previousServices.length - 1) {
        widgets.add(15.verticalSpace); // Spacing between cards
      }
    }

    return widgets;
  }
}

