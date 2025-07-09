import 'dart:convert';
import 'dart:math';

import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/login/login_request.dart';
import 'package:community_app/core/model/login/login_response.dart';
import 'package:community_app/core/remote/services/auth_repository.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
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
    await _loadRememberMeData();
  }

  Future<void> initNotifier() async {
    await loadUserRole();
  }

  Future<void> _loadRememberMeData() async {
    // String? data = await SecureStorageService.getRememberMe();
    // if (data != null) {
    //   final json = jsonDecode(data);
    //   userNameController.text = json['userName'] ?? '';
    //   passwordController.text = json['password'] ?? '';
    //   isChecked = true;
    //   notifyListeners();
    // }
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

  Future<void> performLogin(BuildContext context) async {
    if (!validateAndSave()) return;

    try {
      final request = LoginRequest(
        email: userNameController.text.trim(),
        password: passwordController.text.trim(),
      );

      final result = await AuthRepository().apiUserLogin(request);

      await _handleLoginSuccess(result as LoginResponse, context);
    } catch (e, stackTrace) {
      ToastHelper.showError('An error occurred. Please try again.');
      loginError = 'An error occurred';
      print(e);
      print(stackTrace);
      notifyListeners();
    }
  }

  Future<void> _handleLoginSuccess(LoginResponse result, BuildContext context) async {
    // if (isChecked) {
    //   await SecureStorageService.setRememberMe(jsonEncode({
    //     'userName': userNameController.text,
    //     'password': passwordController.text,
    //   }));
    // } else {
    //   await SecureStorageService.removeRememberMe();
    // }

    ToastHelper.showSuccess('Login Successful');
    if(result.type == "C") {
      Navigator.pushReplacementNamed(context, AppRoutes.vendorBottomBar, arguments: 0);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.vendorBottomBar, arguments: 0);
    }
  }

  void disposeControllers() {
    userNameController.dispose();
    passwordController.dispose();
    captchaController.dispose();
  }
}
