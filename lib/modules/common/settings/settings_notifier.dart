import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/notifier/language_notifier.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:Xception/utils/storage/hive_storage.dart';
import 'package:Xception/utils/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsNotifier extends BaseChangeNotifier {
  bool _notificationSwitch = true;

  void changeLanguage(BuildContext context) {
    final langNotifier = context.read<LanguageNotifier>();
    langNotifier.switchLanguage();
  }

  SettingsNotifier() {
    initializeData();
  }

  void initializeData() async {
    await loadUserData();
    final savedValue = HiveStorageService.getNotification();
    if (savedValue != null) {
      _notificationSwitch = savedValue == true;
    }
    notifyListeners();
  }

  Future<void> toggleNotifications() async {
    notificationSwitch = !notificationSwitch;
    await HiveStorageService.setNotification(notificationSwitch);
    debugPrint("Notifications toggled: $notificationSwitch");
  }

  void handleNavigation(BuildContext context, String routeKey) {
    switch (routeKey) {
      case 'edit-profile':
        Navigator.pushNamed(context, AppRoutes.editProfile).then((value) {
          initializeData();
        });
        break;
      case 'edit-jobs':
        Navigator.pushNamed(context, AppRoutes.vendorOnboarding, arguments: true).then((value) {
          initializeData();
        });
        break;
      case 'change-password':
        Navigator.pushNamed(context, AppRoutes.changePassword);
        break;
      case 'delete-account':
        Navigator.pushNamed(context, AppRoutes.deleteAccount);
        break;
      case 'saved-cards':
        Navigator.pushNamed(context, AppRoutes.savedCards);
        break;
      case 'change-language':
        changeLanguage(context);
        break;
      case 'notifications':
        toggleNotifications();
        break;
      case 'about-us':
        Navigator.pushNamed(context, AppRoutes.aboutUs);
        break;
      case 'privacy-policy':
        Navigator.pushNamed(context, AppRoutes.privacyPolicy);
        break;
      case 'logout':
        Navigator.pushNamed(context, '/logout');
        break;
    }
  }

  Future<void> logoutFunctionality(BuildContext context) async {
    await SecureStorageService.clearData();
    await HiveStorageService.clearOnLogout();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  bool get notificationSwitch => _notificationSwitch;

  set notificationSwitch(bool value) {
    if (_notificationSwitch != value) {
      _notificationSwitch = value;
      notifyListeners();
    }
  }
}
