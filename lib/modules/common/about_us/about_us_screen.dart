import 'package:community_app/modules/common/about_us/about_us_notifier.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AboutUsNotifier(),
      child: Consumer<AboutUsNotifier>(
        builder: (context, aboutUsNotifier, child) {
          return _buildBody(context, aboutUsNotifier);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, AboutUsNotifier notifier) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifier.privacyPolicy.length,
        itemBuilder: (context, index) {
          final section = notifier.privacyPolicy[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                section['title'] == "About Us - Xception Technologies LLC"
                    ? Center(
                  child: Text(
                    section['title'],
                    style: AppFonts.text24.bold.style,
                  ),
                )
                    : Text(
                  section['title'],
                  style: AppFonts.text18.bold.style,
                ),
                8.verticalSpace,
                ...List<Widget>.from(
                  (section['content'] as List<String>).map(
                        (paragraph) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(paragraph, style: AppFonts.text14.regular.style),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}