import 'package:Xception/res/colors.dart';
import 'package:Xception/res/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showDrawer;
  final bool showBackButton;
  const CustomAppBar({super.key, this.showDrawer = false, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80, // replaces preferredSize
      leadingWidth: 60,
      backgroundColor: AppColors.primary,
      leading: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: showDrawer ? InkWell(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Icon(LucideIcons.logs, color: AppColors.white, size: 25.r)
        ) : showBackButton ? _buildBackButton(context) : null,
      ),

      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,      // iOS (dark text → black, set to .dark for proper contrast)
      ),
      centerTitle: true,
      title: Image.asset(AppImages.logo, height: 60),
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.only(right: 14.0),
      //     child: Icon(LucideIcons.bell, color: AppColors.white, size: 25.r),
      //   ),
      // ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.white),
          shape: BoxShape.circle,
        ),
        child: Icon(LucideIcons.arrowLeft, color: AppColors.white, size: 20.r),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}

