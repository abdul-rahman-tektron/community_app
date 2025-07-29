import 'dart:convert';
import 'dart:math';

import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/error/error_response.dart';
import 'package:community_app/core/model/common/login/login_request.dart';
import 'package:community_app/core/model/common/login/login_response.dart';
import 'package:community_app/core/model/common/remember_me/remember_me_model.dart';
import 'package:community_app/core/remote/services/auth_repository.dart';
import 'package:community_app/res/strings.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/storage/hive_storage.dart';
import 'package:community_app/utils/storage/secure_storage.dart';
import 'package:flutter/material.dart';

class LoginNotifier extends BaseChangeNotifier {
  // Controllers
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();

  // Captcha + Remember Me
  String? captchaImage;
  String generatedCaptcha = '';
  bool isChecked = false;
  String captchaError = '';
  String loginError = '';

  // Form
  final formKey = GlobalKey<FormState>();

  LoginNotifier() {
    initNotifier();
    _init();
  }

  Future<void> _init() async {
    await rememberMeData();
  }

  Future<void> initNotifier() async {
    await loadUserRole();
  }

  void toggleRememberMe(bool? value) {
    isChecked = value ?? false;
    notifyListeners();
  }

  void generateNewCaptcha() {
    generatedCaptcha = _generateRandomDigits(6);
    captchaController.clear();
    notifyListeners();
  }

  String _generateRandomDigits(int length) {
    final rand = Random();
    return List.generate(length, (_) => rand.nextInt(10)).join();
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Load remember me data from storage
  Future<void> rememberMeData() async {
    String? data = HiveStorageService.getRememberMe();
    if (data != null) {
      RememberMeModel rememberMeModel = RememberMeModel.fromJson(jsonDecode(data));
      userNameController.text = rememberMeModel.userName;
      passwordController.text = rememberMeModel.password;
      isChecked = true;
    }
  }

  Future<void> _handleRememberMe() async {
    if (isChecked) {
      final rememberData = RememberMeModel(
        userName: userNameController.text,
        password: passwordController.text,
      );
      HiveStorageService.setRememberMe(jsonEncode(rememberData));
    } else {
      await HiveStorageService.remove(AppStrings.rememberMeKey);
    }
  }


  Future<void> performLogin(BuildContext context) async {
    if (!validateAndSave()) return;

    final request = LoginRequest(
      email: userNameController.text.trim(),
      password: passwordController.text.trim(),
    );

    try {
      final result = await AuthRepository().apiUserLogin(request);

      if (result is LoginResponse) {
        await _handleLoginSuccess(result, context);
      } else if (result is ErrorResponse) {
        ToastHelper.showError(result.title ?? 'Login failed.');
        loginError = result.title ?? 'Login failed';
        notifyListeners();
      }
    } catch (e, stackTrace) {
      ToastHelper.showError('An unexpected error occurred.');
      loginError = 'Unexpected error';
      debugPrint('Login Exception: $e');
      debugPrint('StackTrace: $stackTrace');
      notifyListeners();
    }
  }


  Future<void> _handleLoginSuccess(LoginResponse result, BuildContext context) async {

    _handleRememberMe();

    ToastHelper.showSuccess('Login successful');

    // Navigate to role-based home (example shown here)
    if(result.type == "V") {
      HiveStorageService.setUserCategory(UserRole.vendor.name);
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.vendorBottomBar,
        arguments: 0,
      );
    } else {
      HiveStorageService.setUserCategory(UserRole.tenant.name);
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.customerBottomBar,
        arguments: {'currentIndex': 0},
      );
    }
  }


  void disposeControllers() {
    userNameController.dispose();
    passwordController.dispose();
    captchaController.dispose();
  }
}
