import 'package:Xception/modules/vendor/quotation/quotation_notifier.dart';
import 'package:Xception/modules/vendor/quotation/widgets/new_request/new_request_screen.dart';
import 'package:Xception/modules/vendor/quotation/widgets/sent_quotation/sent_quotation_screen.dart';
import 'package:Xception/res/colors.dart';
import 'package:Xception/res/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class QuotationScreen extends StatelessWidget {
  final int? currentIndex;
  const QuotationScreen({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChangeNotifierProvider(
        create: (context) => QuotationNotifier(currentIndex),
        child: Consumer<QuotationNotifier>(
          builder: (context, quotationNotifier, child) {
            return buildBody(context, quotationNotifier);
          },
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context, QuotationNotifier quotationNotifier) {
    return DefaultTabController(
      length: 2,
      initialIndex: quotationNotifier.selectedIndex,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: tabBar(context, quotationNotifier),
            ),
            tabBarView(context, quotationNotifier),
          ],
        ),
      ),
    );
  }

  Widget tabBar(BuildContext context, QuotationNotifier quotationNotifier) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 45.h),
      child: Container(
        padding: EdgeInsets.all(0), // space around the indicator
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.white,
          boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 7)],
        ),
        child: TabBar(
          labelColor: AppColors.primary,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: AppColors.primary, width: 3.0),
            borderRadius: BorderRadius.circular(10)
          ),
          onTap: (index) {
            quotationNotifier.selectedIndex = index;
            if (index == 0) {
            } else {
            }
          },
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: AppFonts.text14.regular.style,
          unselectedLabelStyle: AppFonts.text14.regular.style,
          tabs: [
            Tab(text: "New Request"),
            Tab(text: "Quotation"),
            // Tab(text: "Site Visit"),
          ],
        ),
      ),
    );
  }

  Widget tabBarView(BuildContext context, QuotationNotifier quotationNotifier) {
    return Expanded(child: TabBarView(children: [
      NewRequestScreen(),
      SentQuotationScreen(),
      // SiteVisitScreen()
    ],),);
  }
}
