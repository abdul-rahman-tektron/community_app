import 'package:community_app/modules/customer/services/services_notifier.dart';
import 'package:community_app/modules/customer/services/widgets/previous_services_card.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviousServicesWidget extends StatelessWidget {
  final List<ServiceModel> previousServices;

  const                                                                                                                                                                                                                                                              PreviousServicesWidget({super.key, required this.previousServices});

  @override
  Widget build(BuildContext context) {
    if (previousServices.isEmpty) {
      return Text("No previous services", style: AppFonts.text14.medium.style);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.verticalSpace,
        ..._buildCardListWithSpacing(),
      ],
    );
  }

  Widget _buildHeadingWithGradientUnderline(BuildContext context) {
    final text = "Previous Services";
    final style = AppFonts.text20.semiBold.style;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: style),
          6.verticalSpace,
          _buildGradientUnderline(text, style),
        ],
      ),
    );
  }

  Widget _buildGradientUnderline(String text, TextStyle style) {
    final textWidth = _getTextWidth(text, style);

    return Container(
      height: 2,
      width: textWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.primary.withOpacity(0.5),
            AppColors.primary,
            AppColors.primary.withOpacity(0.5),
            Colors.transparent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.width;
  }

  List<Widget> _buildCardListWithSpacing() {
    final List<Widget> widgets = [];

    for (int i = 0; i < previousServices.length; i++) {
      widgets.add(PreviousServiceCard(service: previousServices[i]));
      if (i != previousServices.length - 1) {
        widgets.add(20.verticalSpace); // Spacing between cards
      }
    }

    return widgets;
  }
}

