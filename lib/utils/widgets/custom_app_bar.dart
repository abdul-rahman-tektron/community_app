import 'package:community_app/res/colors.dart';
import 'package:community_app/res/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundSecondary,
      leading: InkWell(
        onTap: () => Scaffold.of(context).openDrawer(),
        child: Icon(LucideIcons.logs, color: AppColors.textPrimary, size: 25.r),
      ),
      centerTitle: true,
      title: Image.asset(AppImages.logo, height: 50),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 14.0),
      actions: [
        InkWell(
          child: Icon(LucideIcons.bell, color: AppColors.textPrimary, size: 25.r),
          onTap: () {},
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(65.0);
}
