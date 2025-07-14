import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/notifier/language_notifier.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/storage/hive_storage.dart';
import 'package:community_app/utils/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsNotifier extends BaseChangeNotifier {
  bool _notificationSwitch = false;
  void changeLanguage(BuildContext context) {
    final langNotifier = context.read<LanguageNotifier>();
    langNotifier.switchLanguage();
  }

  SettingsNotifier() {
    initializeData();
  }

  void initializeData() async {
    await loadUserData();
  }
  void toggleNotifications() {
    // Add your notifications logic here
    debugPrint("Notifications toggled");
  }

  void handleNavigation(BuildContext context, String routeKey) {
    switch (routeKey) {
      case 'edit-profile':
        Navigator.pushNamed(context, '/edit-profile');
        break;
      case 'change-password':
        Navigator.pushNamed(context, '/change-password');
        break;
      case 'delete-account':
        Navigator.pushNamed(context, '/delete-account');
        break;
      case 'saved-cards':
        Navigator.pushNamed(context, '/saved-cards');
        break;
      case 'change-language':
        changeLanguage(context);
        break;
      case 'notifications':
        toggleNotifications();
        break;
      case 'about':
        Navigator.pushNamed(context, '/about');
        break;
      case 'logout':
        Navigator.pushNamed(context, '/logout');
        break;
    }
  }

  void switchNotification() {
    notificationSwitch = !notificationSwitch;
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

  bool get notificationSwitch => _notificationSwitch;
  set notificationSwitch(bool value) {
    if (_notificationSwitch != value) {
      _notificationSwitch = value;
      notifyListeners();
    }
  }
}
