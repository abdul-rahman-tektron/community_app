import 'dart:convert';

import 'package:Xception/core/model/common/login/login_response.dart';
import 'package:Xception/core/model/common/user/update_user_response.dart';
import 'package:Xception/res/colors.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/res/images.dart';
import 'package:Xception/utils/helpers/screen_size.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:Xception/utils/storage/hive_storage.dart';
import 'package:Xception/utils/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int)? onItemSelected;

  const CustomDrawer({super.key, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return SafeArea(
      child: Drawer(
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
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      margin: EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        AppImages.logo,
        height: 100,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildUserDetails() {
    final String? userJson = HiveStorageService.getUserData();
    final LoginResponse? user = userJson != null ? loginResponseFromJson(userJson) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: user?.image != null ? Image.memory(base64Decode(user?.image ?? ""), height: 50,
              width: 50,
              fit: BoxFit.cover,) : Image.asset(
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
                Text(
                  user?.name?.toString() ?? 'Guest User',
                  style: AppFonts.text16.bold.black.style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                4.verticalSpace,
                Text(
                  user?.email ?? 'No email',
                  style: AppFonts.text12.regular.grey.style,
                ),
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
            AppColors.secondary.withOpacity(0.5),
            AppColors.secondary,
            AppColors.secondary.withOpacity(0.5),
            Colors.transparent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    final String? userJson = HiveStorageService.getUserData();
    final LoginResponse? user = userJson != null ? loginResponseFromJson(userJson) : null;

    final items = [
      [LucideIcons.layoutDashboard, "Dashboard", 0],
      [LucideIcons.search, user?.type == "V" ? "Quotation" : "Explore", 1],
      [LucideIcons.brushCleaning, "Jobs", 2],
      [LucideIcons.settings, "Settings", 3],
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
          user ?? LoginResponse(),
        );
      },
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, int value, LoginResponse user) {
    return ListTile(
      leading: Icon(icon, size: 25, color: AppColors.textPrimary),
      title: Text(title, style: AppFonts.text16.medium.style),
      onTap: () {
        _handleNavigation(context, value, user);
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () => logoutFunctionality(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.symmetric(vertical: 8),
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

  void _handleNavigation(BuildContext context, int value, LoginResponse user) {



    Navigator.pop(context);
    if (value >= 0 && value <= 2) {
      Navigator.pop(context);
      if(user.type == "V") {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.vendorBottomBar,
          arguments: {'currentIndex': value},
              (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.customerBottomBar,
          arguments: {'currentIndex': value},
              (route) => false,
        );
      }


    } else if (value == 3) {
      Navigator.pushNamed(
        context,
        AppRoutes.settings
      );
    } else if (value == 7) {
      logoutFunctionality(context);
    }
  }

  Future<void> logoutFunctionality(BuildContext context) async {
    await SecureStorageService.clearData();
    await HiveStorageService.clearOnLogout();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
          (route) => false,
    );
  }
}
