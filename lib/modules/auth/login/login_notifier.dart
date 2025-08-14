import 'dart:convert';
import 'dart:math';

import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/error/error_response.dart';
import 'package:community_app/core/model/common/login/login_request.dart';
import 'package:community_app/core/model/common/login/login_response.dart';
import 'package:community_app/core/model/common/login/register_token_request.dart';
import 'package:community_app/core/model/common/remember_me/remember_me_model.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/res/api_constants.dart';
import 'package:community_app/res/strings.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/helpers/use_pass_service.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/storage/hive_storage.dart';
import 'package:community_app/utils/storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uae_pass/flutter_uae_pass.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class LoginNotifier extends BaseChangeNotifier {
  // Controllers
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();

  final uaePassService = UAEPassService();

  // Captcha + Remember Me
  String? captchaImage;
  String generatedCaptcha = '';
  bool isChecked = false;
  String captchaError = '';
  String loginError = '';

// Dio instance
  final Dio _dio = Dio();

  // Form
  final formKey = GlobalKey<FormState>();

  LoginNotifier() {
    initNotifier();
    _init();
  }

  Future<void> _init() async {
    await rememberMeData();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('*** Dio Request ***');
          debugPrint('URI: ${options.uri}');
          debugPrint('Method: ${options.method}');
          debugPrint('Headers: ${options.headers}');
          debugPrint('Data: ${options.data}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('*** Dio Response ***');
          debugPrint('Status Code: ${response.statusCode}');
          debugPrint('Data: ${response.data}');
          handler.next(response);
        },
        onError: (DioError e, handler) {
          debugPrint('*** Dio Error ***');
          debugPrint('Message: ${e.message}');
          if (e.response != null) {
            debugPrint('Status Code: ${e.response?.statusCode}');
            debugPrint('Data: ${e.response?.data}');
          }
          handler.next(e);
        },
      ),
    );
  }

  Future<void> initNotifier() async {
    await loadUserRole();
    await uaePassService.initialize(isProduction: false);
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
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $fcmToken");
    if (fcmToken == null) return;
    try {

      final parsed = await CommonRepository.instance.apiRegisterToken(
        RegisterTokenRequest(userId: userNameController.text, token: fcmToken),
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

    ToastHelper.showSuccess('Login successful');

    await apiRegisterToken();

    // Navigate to role-based home (example shown here)
    if(result.type == "V") {
      HiveStorageService.setUserCategory(UserRole.vendor.name);
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.vendorBottomBar,
        arguments: {'currentIndex': 0},
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
