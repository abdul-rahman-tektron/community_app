import 'package:community_app/utils/storage/hive_storage.dart';
import 'package:flutter/material.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/router/routes.dart';

class UserRoleSelectionNotifier extends ChangeNotifier {
  UserRole? _userRole;

  UserRole? get userRole => _userRole;

  void selectRoleAndNavigate(BuildContext context, UserRole selectedRole) {
    print("selectedRole");
    print(selectedRole);
    _userRole = selectedRole;

    HiveStorageService.setUserCategory(selectedRole.name);
    notifyListeners();

    Navigator.pushNamed(context, AppRoutes.login);
  }
}