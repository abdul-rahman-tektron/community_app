import 'package:Xception/res/colors.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/utils/enums.dart';
import 'package:Xception/utils/helpers/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final UserRole userRole;
  final Function(int) onTap;

  CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.userRole,
    required this.onTap,
  });

  // Customer (tenant or owner)
  final List<IconData> _customerIcons = [
    LucideIcons.layoutDashboard,
    LucideIcons.search,
    LucideIcons.brushCleaning,
  ];

  final List<String> _customerLabels = [
    "Dashboard",
    "Explore",
    "Jobs",
  ];

  // Vendor
  final List<IconData> _vendorIcons = [
    LucideIcons.layoutDashboard,
    LucideIcons.badgePercent,
    LucideIcons.brushCleaning,
  ];

  final List<String> _vendorLabels = [
    "Dashboard",
    "Quotation",
    "Jobs",
  ];

  bool get isCustomer => userRole == UserRole.tenant || userRole == UserRole.owner;

  List<IconData> get _icons => isCustomer ? _customerIcons : _vendorIcons;
  List<String> get _labels => isCustomer ? _customerLabels : _vendorLabels;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      height: 70,
      child: Row(
        children: List.generate(_icons.length, (index) {
          final bool isSelected = index == currentIndex;
          return Expanded(
            child: Center(
              child: InkWell(
                onTap: () => onTap(index),
                borderRadius: BorderRadius.circular(50),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.9),
                        AppColors.primary.withOpacity(0.85),
                        AppColors.primary.withOpacity(0.65),
                        AppColors.primary.withOpacity(0.85),
                        AppColors.primary.withOpacity(0.9),
                        AppColors.primary,
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: const [0.0, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0],
                    )
                        : null,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _icons[index],
                              size: isSelected ? ScreenSize.width < 380 ? 18 : 22 : ScreenSize.width < 380 ? 18 : 22,
                              color: isSelected ? AppColors.white : AppColors.textPrimary,
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) =>
                                  FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                              child: isSelected
                                  ? Padding(
                                key: ValueKey(index),
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  _labels[index],
                                  style: AppFonts.text12.semiBold.white.style.copyWith(
                                    fontSize: ScreenSize.width < 380 ? 10 : 12,
                                  ),
                                ),
                              )
                                  : Padding(
                                key: ValueKey(index),
                                padding: const EdgeInsets.only(left: 6),
                                child: Text(
                                  _labels[index],
                                  style: AppFonts.text12.semiBold.style.copyWith(
                                    fontSize: ScreenSize.width < 380 ? 10 : 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
