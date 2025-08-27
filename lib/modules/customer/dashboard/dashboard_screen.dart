import 'package:carousel_slider/carousel_slider.dart';
import 'package:community_app/core/model/common/dropdown/service_dropdown_response.dart';
import 'package:community_app/modules/customer/dashboard/dashboard_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class CustomerDashboardScreen extends StatelessWidget {
  final void Function(ServiceDropdownData category)? onCategoryTap;
  const CustomerDashboardScreen({super.key, this.onCategoryTap});

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPromotionsCard(context, notifier),
                        // _buildPromoDots(notifier),
                        15.verticalSpace,
                        // _buildServiceCounts(notifier),
                        _buildQuickStatsGrid(notifier),
                        20.verticalSpace,
                        Row(
                          children: [
                            Expanded(child: _buildHeader("Categories")),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.customerBottomBar,
                                  arguments: {'currentIndex': 1},
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: Row(
                                  children: [
                                    Text("view all", style: AppFonts.text14.regular.style),
                                    3.horizontalSpace,
                                    Icon(LucideIcons.chevronRight, size: 16.sp),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        _buildCategoryChips(context, notifier),
                        20.verticalSpace,
                        // _buildHeader("Quick Access"),
                        _buildQuickActions(context, notifier),
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
    return Stack(
      children: [
        // Carousel
        CarouselSlider.builder(
          itemCount: notifier.promotions.length,
          options: CarouselOptions(
            height: 250,
            viewportFraction: 1, // Full width
            autoPlay: true,
            enlargeCenterPage: false,
            enableInfiniteScroll: true,
            onPageChanged: (index, _) => notifier.updatePromotionIndex(index),
          ),
          itemBuilder: (context, index, realIndex) {
            final promo = notifier.promotions[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(blurRadius: 6, color: Colors.black45),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: CustomButton(
                      onPressed: () {
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
        ),

        // Dots (always static)
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(notifier.promotions.length, (dotIndex) {
              final isActive = dotIndex == notifier.currentPromotionIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isActive ? 12 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }



  Widget _buildCategoryChips(BuildContext context, CustomerDashboardNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: SizedBox(
        width: double.infinity, // Take full width
        child: Wrap(
          spacing: 25,
          runSpacing: 15,
          alignment: WrapAlignment.center, // Center horizontally
          runAlignment: WrapAlignment.center, // Center vertically in each row
            children: List.generate(notifier.categoriesData.length, (index) {
              final category = notifier.categoriesData[index];
              final iconColor = notifier.chipIconColors[index % notifier.chipIconColors.length];

              return GestureDetector(
                onTap: () {
                  if (onCategoryTap != null) {
                    onCategoryTap!(category);
                  } else {
                    notifier.selectCategory(context, category);
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        notifier.getServiceIcon(category.serviceName ?? ""),
                        color: iconColor,
                        size: 25,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 70,
                      child: Text(
                        category.serviceName ?? "",
                        textAlign: TextAlign.center,
                        style: AppFonts.text12.regular.style,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ),
      ),
    );
  }

  Widget _buildQuickStatsGrid(CustomerDashboardNotifier notifier) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: notifier.quickStats.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 1,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemBuilder: (context, index) {
        final stat = notifier.quickStats[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: AppStyles.commonDecoration,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(color: stat.iconBgColor, borderRadius: BorderRadius.circular(8.r)),
                child: Icon(stat.icon, color: stat.iconColor, size: 20.w),
              ),
              15.horizontalSpace,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stat.count.toString(), style: AppFonts.text18.semiBold.style, overflow: TextOverflow.ellipsis),
                    2.verticalSpace,
                    Text(stat.label, style: AppFonts.text14.regular.style),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(title, style: AppFonts.text16.semiBold.style),
    );
  }

  Widget _buildQuickActions(BuildContext context, CustomerDashboardNotifier notifier) {
    final iconColors = notifier.chipIconColors;

    return Container(
       width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              AppImages.backgroundPattern),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 2 / 1,
          children: List.generate(notifier.quickActions.length, (index) {
            final action = notifier.quickActions[index];
            final iconColor = iconColors[index % iconColors.length];

            return GestureDetector(
              onTap: () {
                if (action.label == "New Service") {
                  Navigator.pushNamed(context, AppRoutes.newServices);
                } else if(action.label == "Pending Quotation") {
                  Navigator.pushNamed(context, AppRoutes.quotationRequestList);
                } else if(action.label == "Track Request") {
                  Navigator.pushNamed(context, AppRoutes.tracking);
                } else if(action.label == "Make Payment") {
                  Navigator.pushNamed(context, AppRoutes.payment);
                }
              },
              child: Container(
                decoration: AppStyles.commonDecoration,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(action.icon, size: 30, color: AppColors.secondary),
                      10.verticalSpace,
                      Text(action.label),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
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
