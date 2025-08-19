import 'dart:convert';

import 'package:community_app/modules/common/settings/settings_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/res/styles.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsNotifier(),
      child: Consumer<SettingsNotifier>(
        builder: (context, settingsNotifier, _) {
          return Scaffold(
            appBar: CustomAppBar(),
            drawer: CustomDrawer(),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfoHeader(context, settingsNotifier),
                  10.verticalSpace,
                  _buildSettingsGroup(
                    [
                      _tileData(LucideIcons.userRoundPen, "Edit Profile", 'edit-profile'),
                      _tileData(LucideIcons.lock, "Change Password", 'change-password'),
                      _tileData(LucideIcons.trash, "Delete Account", 'delete-account', isDestructive: true),
                    ],
                    context,
                    settingsNotifier,
                  ),
                  //
                  _buildSettingsGroup(
                    [
                      _tileData(LucideIcons.languages, "Change Language", 'change-language'),
                      _tileData(LucideIcons.bell, "Notifications", 'notifications'),
                    ],
                    context,
                    settingsNotifier,
                  ),
                  _buildSettingsGroup(
                    [
                      _tileData(LucideIcons.info, "About", 'about'),
                      _tileData(LucideIcons.globeLock, "Privacy Policy", 'privacy-policy'),
                    ],
                    context,
                    settingsNotifier,
                  ),
                  _buildLogoutButton(context, settingsNotifier),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoHeader(BuildContext context, SettingsNotifier settingsNotifier) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: AppColors.backgroundSecondary),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  height: 120.h,
                  width: 120.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: settingsNotifier.userData?.image != null ? Image.memory(
                        base64Decode(settingsNotifier.userData?.image ?? ""), fit: BoxFit.cover) : Image.asset(
                      AppImages.userPlaceHolder,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 120.h,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(settingsNotifier.userData?.name ?? "", style: AppFonts.text22.regular.style),
                          5.verticalSpace,
                          Text(settingsNotifier.userData?.email ?? "", style: AppFonts.text14.regular.style),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsGroup(List<_SettingsTileData> tiles, BuildContext context, SettingsNotifier notifier) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: AppStyles.commonDecoration,
      child: Column(
        children: tiles
            .map(
              (tile) => _buildSettingsTile(
                context,
                notifier,
                tile.icon,
                tile.title,
                () => notifier.handleNavigation(context, tile.routeKey),
                isDestructive: tile.isDestructive,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    SettingsNotifier notifier,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: isDestructive ? AppColors.error : AppColors.polylineColor, size: 20),
      title: Text(title, style: AppFonts.text14.regular.style.copyWith(color: isDestructive ? AppColors.error : null)),
      trailing: trailingWidget(context, notifier, title),
      onTap: onTap,
    );
  }

  Widget trailingWidget(BuildContext context, SettingsNotifier settingsNotifier, String title) {
    if (title == "Change Language") {
      return Text(
        context.locale.switchLng,
        style: FontResolver.resolve(context.locale.switchLng, AppFonts.text16.semiBold.style),
      );
    } else if (title == "Notifications") {
      return Transform.scale(
        scale: 0.9,
        child: Switch(padding: EdgeInsets.zero,
            activeColor: AppColors.primary,
            thumbColor: WidgetStateProperty.all(AppColors.white),
            trackColor:WidgetStateProperty.resolveWith((states) {
              // When false, thumb color is red
              if (!settingsNotifier.notificationSwitch) return AppColors.primary.withOpacity(0.3);

              // When true, thumb color is green
              return AppColors.primary;
            }),
            trackOutlineColor: WidgetStateProperty.all(AppColors.white),
            value: settingsNotifier.notificationSwitch, onChanged: (bool value) {
              settingsNotifier.toggleNotifications();
            }),
      );
    }

    return const Icon(Icons.arrow_forward_ios, size: 16);
  }

  Widget _buildLogoutButton(BuildContext context, SettingsNotifier notifier) {
    return InkWell(
      onTap: () => notifier.logoutFunctionality(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(8)),
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

  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Icon(LucideIcons.arrowLeft),
        ),
      ),
    );
  }
}

class _SettingsTileData {
  final IconData icon;
  final String title;
  final String routeKey;
  final bool isDestructive;

  const _SettingsTileData(this.icon, this.title, this.routeKey, {this.isDestructive = false});
}

_SettingsTileData _tileData(IconData icon, String title, String routeKey, {bool isDestructive = false}) {
  return _SettingsTileData(icon, title, routeKey, isDestructive: isDestructive);
}
