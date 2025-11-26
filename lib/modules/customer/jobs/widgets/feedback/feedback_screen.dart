import 'package:Xception/modules/customer/jobs/widgets/feedback/feedback_notifier.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/utils/widgets/custom_app_bar.dart';
import 'package:Xception/utils/widgets/custom_buttons.dart';
import 'package:Xception/utils/widgets/custom_drawer.dart';
import 'package:Xception/utils/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatelessWidget {
  final int? jobId;
  const FeedbackScreen({super.key, this.jobId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FeedbackNotifier(jobId),
      child: Consumer<FeedbackNotifier>(
        builder: (context, feedbackNotifier, child) {
          return buildBody(context, feedbackNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, FeedbackNotifier feedbackNotifier) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: const CustomDrawer(),
      persistentFooterButtons: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
          child: CustomButton(text: "Submit", onPressed: () {
            feedbackNotifier.apiUpdateCustomerJobCompletion(
              context,
              feedbackNotifier,
              jobId ?? 0,
              feedbackNotifier.userData?.name ?? "",
            );
          }),
        ),
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildPaymentSuccessCard(),
            15.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w,),
              child: Text(
                "Thank you for using our service!",
                textAlign: TextAlign.center,
                style: AppFonts.text16.bold.style,
              ),
            ),
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w,),
              child: Text(
                "We value your feedback—please share your experience to help us improve in the future.",
                textAlign: TextAlign.center,
                style: AppFonts.text14.regular.style,
              ),
            ),

            10.verticalSpace,
            // Service Feedback
            buildFeedbackWidget(
              title: "Feedback",
              rating: feedbackNotifier.serviceRating,
              controller: feedbackNotifier.serviceCommentController,
              onEmojiTap: (index) {
                feedbackNotifier.updateServiceRating(index.toDouble());
              },
            ),
            // 10.verticalSpace,
            // Vendor Feedback
            // buildFeedbackWidget(
            //   title: "Vendor Feedback",
            //   rating: feedbackNotifier.vendorRating,
            //   controller: feedbackNotifier.vendorCommentController,
            //   onEmojiTap: (index) {
            //     feedbackNotifier.updateVendorRating(index.toDouble());
            //   },
            // ),

            // 20.verticalSpace,

          ],
        ),
      ),
    );
  }

  Widget buildPaymentSuccessCard() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(25.w),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Color(0xFF072f5f), Color(0xFF2F80ED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 6))],
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.creditCard, color: Colors.white, size: 28),
                    SizedBox(width: 10),
                    Text(
                      "Payment Successful",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // Fake card number line
                Container(
                  width: double.infinity,
                  height: 16.h,
                  color: Colors.white24,
                  margin: EdgeInsets.only(top: 12.h, bottom: 4.h),
                ),
                // Row with two fake lines for expiry and name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        Container(width: 30.w, height: 12.h, color: Colors.white30),
                        Text(" / ", style: AppFonts.text22.medium.white.style),
                        Container(width: 30.w, height: 12.h, color: Colors.white30),
                      ],
                    ),
                    Container(width: 80.w, height: 14.h, color: Colors.white30),
                  ],
                ),
              ],
            ),
          ),

          // Big centered check icon
          CircleAvatar(
            radius: 45.w,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 43.w,
              backgroundColor: Colors.green,
              child: Icon(LucideIcons.check, size: 50.w, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFeedbackWidget({
    required String title,
    required double rating,
    required Function(int) onEmojiTap,
    required TextEditingController controller,
  }) {
    final List<Map<String, dynamic>> ratings = [
      {
        'label': 'Very Bad',
        'icon': Icons.sentiment_very_dissatisfied,
        'color': Colors.red,
      },
      {
        'label': 'Poor',
        'icon': Icons.sentiment_dissatisfied,
        'color': Colors.orange,
      },
      {
        'label': 'Neutral',
        'icon': Icons.sentiment_neutral,
        'color': Colors.amber,
      },
      {
        'label': 'Good',
        'icon': Icons.sentiment_satisfied,
        'color': Colors.green,
      },
      {
        'label': 'Excellent',
        'icon': Icons.sentiment_very_satisfied,
        'color': Colors.green[800],
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          // SizedBox(height: 12.h),
          CustomTextField(
            controller: controller,
            fieldName: "Feedback",
            titleVisibility: false,
            isMaxLines: true,
            hintText: "Add Feedback",
          ),
          20.verticalSpace,
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(ratings.length, (index) {
                final isSelected = index + 1 == rating;
                final iconColor = isSelected ? ratings[index]['color'] : Colors.grey;

                return GestureDetector(
                  onTap: () => onEmojiTap(index + 1),
                  child: Column(
                    children: [
                      Icon(
                        ratings[index]['icon'],
                        size: 32.sp,
                        color: iconColor,
                      ),
                      4.verticalSpace,
                      Text(
                        ratings[index]['label'],
                        style: TextStyle(
                          color: iconColor,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

}
