import 'dart:convert';
import 'dart:math';

import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/model/common/error/error_response.dart';
import 'package:Xception/core/model/common/login/login_request.dart';
import 'package:Xception/core/model/common/login/login_response.dart';
import 'package:Xception/core/model/common/login/register_token_request.dart';
import 'package:Xception/core/model/common/remember_me/remember_me_model.dart';
import 'package:Xception/core/remote/services/common_repository.dart';
import 'package:Xception/res/strings.dart';
import 'package:Xception/utils/enums.dart';
import 'package:Xception/utils/helpers/toast_helper.dart';
import 'package:Xception/utils/helpers/use_pass_service.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:Xception/utils/storage/hive_storage.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class LoginNotifier extends BaseChangeNotifier {
  // Controllers
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final uaePassService = UAEPassService();

  bool isChecked = false;
  bool? isOnboarded;
  String loginError = '';

  // Form
  final formKey = GlobalKey<FormState>();

  LoginNotifier() {
    initNotifier();
    _init();
  }

  Future<void> _init() async {
    await rememberMeData();
    await isOnboardedData();
  }

  Future<void> initNotifier() async {
    await loadUserRole();
    await uaePassService.initialize(isProduction: false);
  }

  void toggleRememberMe(bool? value) {
    isChecked = value ?? false;
    notifyListeners();
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

  // Load remember me data from storage
  Future<void> isOnboardedData() async {
    bool data = HiveStorageService.getOnboardingCompleted();

    isOnboarded = data;
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
      final result = await CommonRepository.instance.apiUserLogin(request);

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

  Future<void> apiRegisterToken() async {
    String fcmToken = '';

    try {
      // Get FCM token safely
      fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      print("FCM Token: $fcmToken");

      // Call your API with the token (empty string if null)
      final parsed = await CommonRepository.instance.apiRegisterToken(
        RegisterTokenRequest(
          userId: userNameController.text,
          token: fcmToken,
        ),
      );
    } catch (e, stackTrace) {
      print("❌ Error updating Token: $e");
      print("Stack: $stackTrace");
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      notifyListeners();
    }
  }

  Future<void> performUaePass(BuildContext context) async {
    try {
      String accessToken = await uaePassService.signIn(context);

      if (accessToken.isNotEmpty) {
        final profile = await uaePassService.getUserProfile(accessToken);

        if (profile != null) {
          // You can process or save profile data here as needed
          print('Profile Data: $profile');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login Success! Welcome ${profile['fullnameEN'] ?? 'User'}"),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate or do other stuff here
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to fetch profile data."),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("UAE Pass login failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  Future<void> _handleLoginSuccess(LoginResponse result, BuildContext context) async {

    _handleRememberMe();

    if(result.deleted ?? false) {
      ToastHelper.showError('This account doesn\'t exists or has been deleted. kindly register again.');
      return;
    }

    ToastHelper.showSuccess('Login successful');

    await apiRegisterToken();

    // Navigate to role-based home (example shown here)
    if(result.type == "V") {
      HiveStorageService.setUserCategory(UserRole.vendor.name);

      print("isOnboarded");
      print(isOnboarded);

      if(!(result.isOnboarded ?? true)) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.vendorOnboarding,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.vendorBottomBar,
          arguments: {'currentIndex': 0},
        );
      }
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
  }
}
