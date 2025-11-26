import 'package:Xception/modules/common/privacy_policy/privacy_policy_notifier.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/utils/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PrivacyPolicyNotifier(),
      child: Consumer<PrivacyPolicyNotifier>(
        builder: (context, privacyPolicyNotifier, child) {
          return _buildBody(context, privacyPolicyNotifier);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, PrivacyPolicyNotifier notifier) {
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
                section['title'] == "Privacy Policy"
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