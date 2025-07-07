import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/utils/helpers/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final List<IconData> _icons = [
    LucideIcons.layoutDashboard,
    LucideIcons.search,
    LucideIcons.brushCleaning,
  ];

  final List<String> _labels = [
    "Dashboard",
    "Explore",
    "Services",
  ];

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
                    gradient: isSelected ? LinearGradient(
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
                    ) : null,
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
                              size: isSelected ? 22 : 26,
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
                                  style: AppFonts.text12.semiBold.white.style,
                                ),
                              )
                                  : const SizedBox.shrink(key: ValueKey('empty')),
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
