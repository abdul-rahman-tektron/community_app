import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/login/login_request.dart';
import 'package:community_app/core/model/register/customer_register_request.dart';
import 'package:community_app/core/remote/services/auth_repository.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';

class CustomerRegistrationNotifier extends BaseChangeNotifier {
  CustomerRegistrationNotifier() {
    // Initialize controllers
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final userIdController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final communityController = TextEditingController();
  final addressController = TextEditingController();
  final buildingController = TextEditingController();
  final blockController = TextEditingController();

  final dummyCommunityList = [
    'Downtown Dubai',
    'Jumeirah Village Circle',
    'Dubai Marina',
    'Business Bay',
    'Palm Jumeirah',
  ];

  String? community;
  bool acceptedPrivacyPolicy = false;
  double? latitude;
  double? longitude;

  void setCommunity(String? value) {
    community = value;
    notifyListeners();
  }

  void togglePrivacyPolicy() {
    acceptedPrivacyPolicy = !acceptedPrivacyPolicy;
    notifyListeners();
  }

  Future<void> performRegistration(BuildContext context) async {

    try {
      await AuthRepository().apiUserLogin(
        LoginRequest(email: "admin@example.com", password: "password"),
      );

      final request = CustomerRegisterRequest(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        mobile: mobileController.text.trim(),
        password: passwordController.text.trim(),
        communityId: 0,
        userId: userIdController.text.trim(),
        address: addressController.text.trim(),
        building: buildingController.text.trim(),
        block: blockController.text.trim(),
        latitude: latitude.toString(),
        longitude: longitude.toString(),
        customerId: 2,
      );

      final result = await AuthRepository().apiCustomerRegister(request);

      await _handleRegisterSuccess(result, context);
    } catch (e) {
      ToastHelper.showError('An error occurred. Please try again.');
      notifyListeners();
    }
  }

  Future<void> _handleRegisterSuccess(dynamic result, BuildContext context) async {
    ToastHelper.showSuccess('Registration Successful');
    Navigator.of(context, rootNavigator: true).pushReplacementNamed(AppRoutes.login);
  }

  void setLatLng(double lat, double lng) {
    latitude = lat;
    longitude = lng;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    communityController.dispose();
    addressController.dispose();
    buildingController.dispose();
    blockController.dispose();
    super.dispose();
  }
}
