import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/utils/helpers/screen_size.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CommonDrawer extends StatelessWidget {
  final Function(int)? onItemSelected;

  const CommonDrawer({super.key, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: ScreenSize.width * 0.8,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          _buildLogo(),
          10.verticalSpace,
          _buildGradientDivider(),
          _buildUserDetails(),
          _buildGradientDivider(),
          15.verticalSpace,
          Expanded(child: _buildMenuList(context)),
          _buildLogoutButton(context),
          15.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Image.asset(
        AppImages.logo,
        height: 60,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildUserDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              AppImages.loginImage,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          15.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mohammed John Doe',
                    style: AppFonts.text16.bold.black.style,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                4.verticalSpace,
                Text('johndoe@example.com',
                    style: AppFonts.text12.regular.grey.style),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientDivider() {
    return Container(
      height: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 16),
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

  Widget _buildMenuList(BuildContext context) {
    final items = [
      [LucideIcons.layoutDashboard, "Dashboard", 0],
      [LucideIcons.search, "Explore", 1],
      [LucideIcons.brushCleaning, "Services", 2],
      [LucideIcons.userRound, "Edit Profile", 3],
      [LucideIcons.lockKeyhole, "Change Password", 4],
    ];

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];
        return _buildDrawerItem(
          context,
          item[0] as IconData,
          item[1] as String,
          item[2] as int,
        );
      },
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, int value) {
    return ListTile(
      leading: Icon(icon, size: 25, color: AppColors.textPrimary),
      title: Text(title, style: AppFonts.text16.medium.style),
      onTap: () {
        Navigator.pop(context);
        _handleNavigation(context, value);
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () => logoutFunctionality(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.symmetric( vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.power, size: 25, color: AppColors.white),
            12.horizontalSpace,
            Text("Logout", style: AppFonts.text18.medium.white.style),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int value) {
    Navigator.pop(context);
    if (value >= 0 && value <= 4) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.customerBottomBar,
        arguments: value,
            (route) => false,
      );
    } else if (value == 7) {
      logoutFunctionality(context);
    }
  }

  Future<void> logoutFunctionality(BuildContext context) async {
    await SecureStorageService.clearData();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
          (route) => false,
    );
  }
}
