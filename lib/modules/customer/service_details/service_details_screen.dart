import 'package:community_app/modules/customer/service_details/service_details_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/helpers/rating_star_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:community_app/utils/widgets/custom_drawer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ServiceDetailsNotifier(),
      child: Consumer<ServiceDetailsNotifier>(
        builder: (context, notifier, child) {
          return buildBody(context, notifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, ServiceDetailsNotifier notifier) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      persistentFooterButtons: [submitButton(context, notifier)],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerSection(context, notifier),
            20.verticalSpace,
            serviceVendorInfoSection(context, notifier),
            20.verticalSpace,
            serviceDescriptionSection(context, notifier),
            20.verticalSpace,
            reviewSection(context, notifier),
            10.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget headerSection(BuildContext context, ServiceDetailsNotifier notifier) {
    final String status = RatingStarHelper.getStatus(notifier.rating);
    final Color statusColor = RatingStarHelper.getStatusColor(notifier.rating);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 180.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://www.southernliving.com/thmb/yT3SGvAjaMSpt6Vwt62nZLeqJkY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-1327576000-fff516a82eff488db59e9b22db013034.jpg",
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 15,
              child: Image.asset(AppImages.logo, height: 70.h, width: 70.w),
            ),
          ],
        ),
        15.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Al Najma Al Fareeda LLC", style: AppFonts.text14.regular.style),
                      Text("Cleaning", style: AppFonts.text20.semiBold.style),
                    ],
                  ),
                ],
              ),
              8.verticalSpace,
              Row(
                children: [
                  RatingStarHelper.buildRatingStars(rating: 4.3),
                  3.horizontalSpace,
                  Text("4.3", style: AppFonts.text14.regular.style),
                  Text(" · $status", style: AppFonts.text14.regular.style.copyWith(color: statusColor)),
                  Text(" · 230 reviews", style: AppFonts.text14.regular.style),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget serviceVendorInfoSection(BuildContext context, ServiceDetailsNotifier notifier) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _iconLabelRow(
            icon: LucideIcons.mapPin,
            label: "13th Building, Al Barsha, Deira, Dubai",
            bgColor: Color(0xffe7f3f9),
            iconColor: Colors.blue,
          ),
          10.verticalSpace,
          _iconLabelRow(
            icon: LucideIcons.mail,
            label: "vendor@example.com",
            bgColor: Color(0xfffdf5e7),
            iconColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _iconLabelRow({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Row(
      children: [
        _iconBox(icon: icon, bgColor: bgColor, iconColor: iconColor),
        10.horizontalSpace,
        Expanded(child: Text(label, style: AppFonts.text14.regular.style)),
      ],
    );
  }

  Widget _iconBox({required IconData icon, required Color bgColor, required Color iconColor}) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  Widget serviceDescriptionSection(BuildContext context, ServiceDetailsNotifier notifier) {
    final String shortDesc = notifier.description.length > 150
        ? notifier.description.substring(0, 150)
        : notifier.description;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          10.verticalSpace,
          RichText(
            text: TextSpan(
              style: AppFonts.text14.regular.style,
              children: [
                TextSpan(text: notifier.showFullDescription ? notifier.description : '$shortDesc...'),
                if (notifier.description.length > 150)
                  TextSpan(
                    text: notifier.showFullDescription ? ' Show Less' : ' Show More',
                    style: AppFonts.text14.semiBold.blue.style,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        notifier.toggleDescription();
                      },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget reviewSection(BuildContext context, ServiceDetailsNotifier notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(15.h),
            decoration: AppStyles.commonDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ratings & Reviews",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                10.verticalSpace,
                buildRatingsSummary(
                  starCounts: {5: 120, 4: 60, 3: 30, 2: 5, 1: 12},
                  overallRating: 4.3,
                  totalReviews: 227,
                ),
              ],
            ),
          ),
          20.verticalSpace,
          ...notifier.reviews.asMap().entries.map((entry) {
            final index = entry.key;
            final review = entry.value;

            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1633332755192-727a05c4013d?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D",
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(review.name, style: TextStyle(fontWeight: FontWeight.bold)),
                              5.horizontalSpace,
                              Text(
                                "(${review.daysAgo})",
                                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                              ),
                            ],
                          ),
                          3.verticalSpace,
                          RatingStarHelper.buildRatingStars(rating: review.rating.toDouble()),
                          3.verticalSpace,
                          Text(review.comment, style: TextStyle(fontSize: 13.sp)),
                        ],
                      ),
                    ),
                  ],
                ),
                if (index != notifier.reviews.length - 1) ...[
                  15.verticalSpace,
                  Divider(height: 1.h, color: Colors.grey.shade300),
                  15.verticalSpace,
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget buildRatingsSummary({
    required Map<int, int> starCounts,
    required double overallRating,
    required int totalReviews,
  }) {
    int maxCount = starCounts.values.isEmpty ? 1 : starCounts.values.reduce((a, b) => a > b ? a : b);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left side: stars + progress bars
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                int star = 5 - index;
                int count = starCounts[star] ?? 0;
                double progress = maxCount == 0 ? 0 : count / maxCount;

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 25.w,
                        child: Text("$star★", style: AppFonts.text16.regular.style),
                      ),
                      5.horizontalSpace,
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 5.h,
                            backgroundColor: Colors.grey.shade300,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      5.horizontalSpace,
                      SizedBox(
                        width: 35.w,
                        child: Text("($count)", style: AppFonts.text14.regular.grey.style),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          // Vertical Divider
          Container(
            width: 1.5.w,
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            color: Colors.grey.shade300,
          ),

          // Right side: rating & review summary
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$overallRating", style: AppFonts.text24.semiBold.style),
                RatingStarHelper.buildRatingStars(rating: overallRating),
                10.verticalSpace,
                Text("$totalReviews ratings and reviews", style: AppFonts.text14.regular.grey.style),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget submitButton(BuildContext context, ServiceDetailsNotifier notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 3.h),
      child: CustomButton(onPressed: () {
        Navigator.pushNamed(context, AppRoutes.newServices);
      }, text: "Enquire Now"),
    );
  }
}
