import 'package:carousel_slider/carousel_slider.dart';
import 'package:community_app/modules/customer/dashboard/dashboard_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class CustomerDashboardScreen extends StatelessWidget {
  const CustomerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomerDashboardNotifier(),
      child: Consumer<CustomerDashboardNotifier>(
        builder: (context, notifier, _) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    // Positioned(
                    //   top: -35.h,
                    //   left: -35.w,
                    //   child: Container(
                    //     height: 230.h,
                    //     width: 230.w,
                    //     decoration: BoxDecoration(
                    //         color: AppColors.primary,
                    //         shape: BoxShape.circle
                    //     ),
                    //   ),
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        _buildPromotionsCard(context, notifier),
                        _buildPromoDots(notifier),
                        15.verticalSpace,
                        _buildServiceCounts(notifier),
                        20.verticalSpace,
                        _buildHeader("Categories"),
                        15.verticalSpace,
                        _buildCategoryChips(context, notifier),
                        20.verticalSpace,
                        _buildHeader("Quick Access"),
                        25.verticalSpace,
                        _buildQuickActions(notifier),
                        30.verticalSpace,
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromotionsCard(BuildContext context, CustomerDashboardNotifier notifier) {
    return CarouselSlider.builder(
      itemCount: notifier.promotions.length,
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        onPageChanged: (index, _) => notifier.updatePromotionIndex(index),
      ),
      itemBuilder: (context, index, realIndex) {
        final promo = notifier.promotions[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(promo.imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.darken,
              ),
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  promo.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(blurRadius: 6, color: Colors.black45),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: CustomButton(
                  onPressed: () {
                    // Handle booking action here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Booking action triggered")),
                    );
                  },
                  fullWidth: false,
                  backgroundColor: AppColors.white.withOpacity(0.6),
                  borderColor: AppColors.textPrimary,
                  textStyle: AppFonts.text14.regular.style,
                  height: 30,
                  text: "Book",
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPromoDots(CustomerDashboardNotifier notifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(notifier.promotions.length, (index) {
        final isActive = index == notifier.currentPromotionIndex;
        return Container(
          width: isActive ? 12 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }


  Widget _buildCategoryChips(BuildContext context, CustomerDashboardNotifier notifier) {
    return SizedBox(
      height: 110.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 15),
        itemCount: notifier.categories.length,
        itemBuilder: (context, index) {
          final category = notifier.categories[index];

          return Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: index == 0 ? 0 : 12,
              right: index == notifier.categories.length - 1 ? 0 : 0,
              bottom: 10,
            ),
            child: GestureDetector(
              onTap: () => notifier.selectCategory(category),
              child: Container(
                width: 100.h,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: AppStyles.commonDecoration,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category.icon,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    10.verticalSpace,
                    Text(
                      category.name,
                      textAlign: TextAlign.center,
                      style: AppFonts.text12.regular.style,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceCounts(CustomerDashboardNotifier notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          _buildCountCard('Ongoing \nServices', notifier.ongoingCount, Colors.orange, LucideIcons.minus),
          15.horizontalSpace,
          _buildCountCard('Completed \nServices', notifier.completedCount, Colors.green, LucideIcons.check),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Text(title, style: AppFonts.text20.semiBold.style),
          3.verticalSpace,
          _buildGradientUnderline(title, AppFonts.text20.semiBold.style),
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

  Widget _buildCountCard(String label, int count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        decoration: AppStyles.commonDecoration,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$count',
                    style: AppFonts.text26.semiBold.style.copyWith(color: color),
                  ),
                  5.verticalSpace,
                  Text(
                    label,
                    style: AppFonts.text16.regular.style,
                  ),
                ],
              ),
            ),
            Positioned(
              top: -15,
              right: -10,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 50,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(CustomerDashboardNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 2.5 / 1,
        children: notifier.quickActions.map((action) {
          return GestureDetector(
            onTap: () {
              // TODO: Navigate to respective screen
            },
            child: Container(
              decoration: AppStyles.commonDecoration,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(action.icon, size: 30, color: AppColors.primary),
                    10.verticalSpace,
                    Text(action.label),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}


class BottomCurvePainter extends CustomPainter {
  final Color color;

  BottomCurvePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path()
      ..lineTo(0, size.height - 40)
      ..quadraticBezierTo(
        size.width / 2, size.height + 40, // Control point (dip)
        size.width, size.height - 40,    // End point
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
